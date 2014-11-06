Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751232AbaKFBzk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 20:55:40 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:58412 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbaKFBzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 20:55:37 -0500
Message-ID: <1415238859.2840.22.camel@debian>
Subject: Re: [PATCH 1/2 v2] x86, mce, severity: extend the the mce_severity
From: Chen Yucong <slaoub@gmail.com>
To: Tony Luck <tony.luck@gmail.com>
Cc: Borislav Petkov <bp@alien8.de>, Andi Kleen <ak@linux.intel.com>,
        aravind.gopalakrishnan@amd.com,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <CA+8MBb+72pZfDke3ZVfY+Vtjqd63wx4qnccKP6H8UiSQrORJSA@mail.gmail.com>
References: <1415162873-1874-1-git-send-email-slaoub@gmail.com>
	 <1415162873-1874-2-git-send-email-slaoub@gmail.com>
	 <CA+8MBb+72pZfDke3ZVfY+Vtjqd63wx4qnccKP6H8UiSQrORJSA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 06 Nov 2014 09:54:19 +0800
Mime-Version: 1.0
X-Mailer: Evolution 3.4.4-3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-11-05 at 10:27 -0800, Tony Luck wrote:
> > +#define  ONEXCP        .excp = NO_EXCP
> 
I'm sorry, this is a typing error. Thanks!

> Shouldn't this be named "NOEXCP" and used in the initializations
> for the deferred and UCNA table entries?
> 
In fact, "NOEXCP" can be used in the initialization for the deferred
and UCNA table entries. But it may affect the following snippet in
do_machine_check().

     /*
      * When machine check was for corrected/deferred handler don't
      * touch, unless we're panicing.
      */
     if ((severity == MCE_KEEP_SEVERITY ||
          severity == MCE_UCNA_SEVERITY) && !no_way_out)
              continue;

If `no_way_out' equals 1, we may need to dump/decode corrected/deferred 
error information. So if we use "NOEXCP" to initialize the deferred and
UCNA table entries, do_machine_check will skip checking deferred/UCNA
entry when `no_way_out' is set to 1.

thx!
cyc

