Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751850AbaJYSl3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 14:41:29 -0400
Received: from mailsec102.isp.belgacom.be ([195.238.20.98]:23487 "EHLO
	mailsec102.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750978AbaJYSl0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 14:41:26 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=qsbIbJLQU8sGrbuCvKIQzsqFhob9I/ci1U+ADm/ASCc= c=1 sm=2
 a=IkcTkHD0fZMA:10 a=DswfTcTIAAAA:8 a=yVeKuNOh8FJU2uiRIXoA:9 a=QEXdDO2ut3YA:10
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvgKALdoS1TD7hTS/2dsb2JhbABcgw6BLIMGtk0GmzMCgQgWAX2EAgEBAQMBIwRSBQsFBAIYAgIYDgICVwYTEYgnDZgMnF+HAI1pAQEBBwIBH4EshHmKADMHgneBVAWqRYlEgX4ggVw7L4JLAQEB
Date: Sat, 25 Oct 2014 11:12:16 +0200 (CEST)
From: Fabian Frederick <fabf@skynet.be>
Reply-To: Fabian Frederick <fabf@skynet.be>
To: Ilya Dryomov <ilya.dryomov@inktank.com>
Cc: netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        Sage Weil <sage@inktank.com>, "David S. Miller" <davem@davemloft.net>
Message-ID: <1805780944.182558.1414228336940.open-xchange@webmail.nmp.skynet.be>
In-Reply-To: <CALFYKtD222g32njwF8nHz0Fbjj4p2512ka9bkADmB6S2QibgYA@mail.gmail.com>
References: <1414080959-6053-1-git-send-email-fabf@skynet.be> <CALFYKtD222g32njwF8nHz0Fbjj4p2512ka9bkADmB6S2QibgYA@mail.gmail.com>
Subject: Re: [PATCH 1/1 net-next] libceph: remove unused variable in
 handle_reply()
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Priority: 3
Importance: Medium
X-Mailer: Open-Xchange Mailer v7.2.2-Rev27
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> On 23 October 2014 at 18:25 Ilya Dryomov <ilya.dryomov@inktank.com> wrote:
>
>
> On Thu, Oct 23, 2014 at 8:15 PM, Fabian Frederick <fabf@skynet.be> wrote:
> > osdmap_epoch is redundant with reassert_epoch and unused.
> >
> > Signed-off-by: Fabian Frederick <fabf@skynet.be>
> > ---
> >  net/ceph/osd_client.c | 2 --
> >  1 file changed, 2 deletions(-)
> >
> > diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> > index f3fc54e..432bd75 100644
> > --- a/net/ceph/osd_client.c
> > +++ b/net/ceph/osd_client.c
> > @@ -1700,7 +1700,6 @@ static void handle_reply(struct ceph_osd_client *osdc,
> > struct ceph_msg *msg,
> >         int err;
> >         u32 reassert_epoch;
> >         u64 reassert_version;
> > -       u32 osdmap_epoch;
> >         int already_completed;
> >         u32 bytes;
> >         unsigned int i;
> > @@ -1725,7 +1724,6 @@ static void handle_reply(struct ceph_osd_client *osdc,
> > struct ceph_msg *msg,
> >         result = ceph_decode_32(&p);
> >         reassert_epoch = ceph_decode_32(&p);
> >         reassert_version = ceph_decode_64(&p);
> > -       osdmap_epoch = ceph_decode_32(&p);
> >
> >         /* lookup */
> >         down_read(&osdc->map_sem);
>
> Hi Fabian,
>
> osdmap_epoch is useful for debugging, but this is wrong anyway -
> ceph_decode_32() has side effects.  Removing it and not adjusting *p
> would make the whole thing blow up pretty fast..
>
> Thanks,
>
>                 Ilya

Hi Ilya,

        osdmap_epoch generates a warning with -Wunused-but-set-variable.
Maybe we could just do ceph_decode_32(&p) and remove it
(it doesn't seem to add a warning) and/or add some comment ?

Regards,
Fabian
