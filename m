Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932449AbaEGJeM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 05:34:12 -0400
Received: from smtp1-g21.free.fr ([212.27.42.1]:7241 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754715AbaEGJdy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 05:33:54 -0400
Date: Wed, 7 May 2014 11:33:52 +0200 (CEST)
From: mattieu.souchaud@free.fr
To: Ingo Molnar <mingo@kernel.org>
Cc: bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Tony Luck <tony.luck@intel.com>
Message-ID: <2103538240.232636551.1399455232411.JavaMail.root@zimbra10-e2.priv.proxad.net>
In-Reply-To: <20140506062710.GB25208@gmail.com>
Subject: Re: [PATCH v2] x86/mce: Improve mcheck_init_device() error handling
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [90.4.158.73]
X-Mailer: Zimbra 7.2.0-GA2598 (ZimbraWebClient - FF3.0 (Linux)/7.2.0-GA2598)
X-Authenticated-User: mattieu.souchaud@free.fr
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, thanks, that's better. I'll put your modifications in the patch v3.

----- Mail original -----
De: "Ingo Molnar" <mingo@kernel.org>
À: "Tony Luck" <tony.luck@intel.com>
Cc: "Mathieu Souchaud" <mattieu.souchaud@free.fr>, bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org, linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Envoyé: Mardi 6 Mai 2014 08:27:10
Objet: Re: [PATCH v2] x86/mce: Improve mcheck_init_device() error handling


* Luck, Tony <tony.luck@intel.com> wrote:

> +err_device_create:
> +	/*
> +	 * mce_device_remove behave properly if mce_device_create was not
> +	 * called on that device.
> +	 */
> +	for_each_possible_cpu(i)
> +		mce_device_remove(i);
> 
> grammar comment "s/behave/behaves/"
> 
> Though perhaps this is better:
> 
> 	/*
> 	 * We didn't keep track of which devices were created above, but
> 	 * even if we had, the set of online cpus might have changed.
> 	 * Play safe and remove for every possible cpu since mce_device_remove()
> 	 * will do the right thing.
> 	 */

and I guess:

s/cpu since/cpu, since/

?

Thanks,

	Ingo
