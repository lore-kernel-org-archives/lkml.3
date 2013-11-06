Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932434Ab3KFOPg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 09:15:36 -0500
Received: from mail.skyhub.de ([78.46.96.112]:58946 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932102Ab3KFOPf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 09:15:35 -0500
Date: Wed, 6 Nov 2013 15:17:41 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, Chen Gong <gong.chen@linux.intel.com>
Subject: Re: [PATCH] Changes to the ACPI/APEI/EINJ debugfs interface
Message-ID: <20131106141740.GA16072@x1.alien8.de>
References: <527940181131657a6@agluck-desk.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <527940181131657a6@agluck-desk.sc.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 05, 2013 at 10:59:36AM -0800, Luck, Tony wrote:
> -static int __einj_error_inject(u32 type, u64 param1, u64 param2)
> +static int __einj_error_inject(u32 type, u32 flags, u64 param1, u64 param2,
> +			       u64 param3, u64 param4)

I wonder if, at some point in the future - not now, necessarily, it'll
be prudent to add an error injection struct descriptor which contains
all those param* thingies and some of them could even be defined as a
union in it in order to make the whole code more readable. Like the
'address' variable, for example, which is valid for multiple error
types...

Just an idea though, so let me throw it out in the open.

-- 
Regards/Gruss,
Boris.
