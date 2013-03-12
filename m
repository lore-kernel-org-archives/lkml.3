Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659Ab3CLTyj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 15:54:39 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:55326 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611Ab3CLTyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 15:54:37 -0400
Message-ID: <1363118073.15011.275.camel@mfleming-mobl1.ger.corp.intel.com>
Subject: Re: [PATCH] efivars: Allow disabling use as a pstore backend
From: Matt Fleming <matt.fleming@intel.com>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
Date: Tue, 12 Mar 2013 19:54:33 +0000
In-Reply-To: <20130311211750.GB8440@thinkpad-t410>
References: <1362678017-2862-1-git-send-email-seth.forshee@canonical.com>
	 <5138FAD9.7050504@zytor.com> <20130307205915.GF24233@thinkpad-t410>
	 <1362694529.15011.211.camel@mfleming-mobl1.ger.corp.intel.com>
	 <513911F9.8050308@zytor.com> <20130311211750.GB8440@thinkpad-t410>
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-03-11 at 16:17 -0500, Seth Forshee wrote:
> Here's a patch that does the command line option. I'm happy with either
> one.

I like the idea, but isn't the logic backwards? I would have expected
s/EFI_VARS_PSTORE_DEFAULT_DISABLE/EFI_VARS_PSTORE/g and then 'default y'
in the Kconfig file to maintain backward compatibility?

Is there a reason that wouldn't work?

I know that Linus has previously denounced setting new Kconfig symbols
to 'y' by default, but I think there's a case here for doing exactly
that since the previous behaviour was always enabled. The networking
folks did something similar recently, where they introduced new Kconfig
symbols for existing functionality that was previously on by default.

[...]

> +#ifdef CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE
> +static bool efivars_pstore_disable = true;
> +#else
> +static bool efivars_pstore_disable = false;
> +#endif
> +module_param_named(pstore_disable, efivars_pstore_disable, bool, 0644);
> +

static bool efivars_pstore_enable = IS_ENABLED(CONFIG_EFI_VARS_PSTORE) ?


