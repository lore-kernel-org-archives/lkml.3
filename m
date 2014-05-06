Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934143AbaEFG1S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 02:27:18 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:36429 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934049AbaEFG1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 02:27:16 -0400
Date: Tue, 6 May 2014 08:27:10 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Mathieu Souchaud <mattieu.souchaud@free.fr>, "bp@alien8.de" <bp@alien8.de>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH v2] x86/mce: Improve mcheck_init_device() error handling
Message-ID: <20140506062710.GB25208@gmail.com>
References: <1399151031-19905-1-git-send-email-mattieu.souchaud@free.fr>
 <3908561D78D1C84285E8C5FCA982C28F327F8E9B@ORSMSX114.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F327F8E9B@ORSMSX114.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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
