Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193Ab3F1U6Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 16:58:16 -0400
Received: from mx3-phx2.redhat.com ([209.132.183.24]:55534 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582Ab3F1U6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 16:58:15 -0400
Date: Fri, 28 Jun 2013 16:57:40 -0400 (EDT)
From: Lenny Szubowicz <lszubowi@redhat.com>
To: Tony Luck <tony.luck@gmail.com>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        n hamaguchi <n.hamaguchi@jp.fujitsu.com>,
        Don Zickus <dzickus@redhat.com>
Message-ID: <1199079191.10029297.1372453060353.JavaMail.root@redhat.com>
In-Reply-To: <CA+8MBbJrU51R5TMV6m4nhAiz2kZQBOcmkeAkEcg-erJhDwrChA@mail.gmail.com>
References: <1372450451-8790-1-git-send-email-lszubowi@redhat.com> <1372450451-8790-3-git-send-email-lszubowi@redhat.com> <CA+8MBbJrU51R5TMV6m4nhAiz2kZQBOcmkeAkEcg-erJhDwrChA@mail.gmail.com>
Subject: Re: [PATCH 2/3] acpi: Eliminate console msg if pstore.backend
 excludes ERST
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.12]
X-Mailer: Zimbra 8.0.3_GA_5664 (ZimbraWebClient - FF17 (Linux)/8.0.3_GA_5664)
Thread-Topic: acpi: Eliminate console msg if pstore.backend excludes ERST
Thread-Index: Cb4+me5MqG8Arusxp5mT8hsG6JNUMA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



----- Original Message -----
> From: "Tony Luck" <tony.luck@gmail.com>
> To: "Lenny Szubowicz" <lszubowi@redhat.com>
> Cc: "Anton Vorontsov" <cbouatmailru@gmail.com>, "Matt Fleming" <matt.fleming@intel.com>, "Linux Kernel Mailing List"
> <linux-kernel@vger.kernel.org>, "n hamaguchi" <n.hamaguchi@jp.fujitsu.com>, "Don Zickus" <dzickus@redhat.com>
> Sent: Friday, June 28, 2013 4:44:51 PM
> Subject: Re: [PATCH 2/3] acpi: Eliminate console msg if pstore.backend excludes ERST
> 
> On Fri, Jun 28, 2013 at 1:14 PM, Lenny Szubowicz <lszubowi@redhat.com> wrote:
> 
> > -               if (pstore_register(&erst_info)) {
> > -                       pr_info(ERST_PFX "Could not register with
> > persistent store\n");
> > +               rc = pstore_register(&erst_info);
> > +               if (rc) {
> > +                       if (rc != -EPERM)
> > +                               pr_info(ERST_PFX
> > +                               "Could not register with persistent
> > store\n");
> > +                       erst_info.buf = NULL;
> > +                       erst_info.bufsize = 0;
> 
> Mismatch between part 1 and part 2 here ... we return -EINVAL if
> our name doesn't match the desired backend ... but you only suppress
> the "Could not register" message for -EPERM
> 
> Or am I confused while just looking at patch fragments?
> 
> -Tony
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

Yes, you are absolutely correct. My [PATCH 1/3] is not what I intended. Thanks!

                         -Lenny.
