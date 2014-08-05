Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932914AbaHEJS4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 05:18:56 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:55034 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932792AbaHEJSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 05:18:52 -0400
Date: Tue, 5 Aug 2014 10:18:48 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: P J P <ppandit@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: 3.12 to 3.13 boot regression bisected - still applies to 3.16
Message-ID: <20140805091848.GN15082@console-pimps.org>
References: <20140804113435.34ed8c76@pluto>
 <20140804122728.GH15082@console-pimps.org>
 <20140804150627.4563b6a7@pluto>
 <20140804135452.GJ15082@console-pimps.org>
 <20140805100242.425e1093@pluto>
 <20140805084542.GM15082@console-pimps.org>
 <20140805111330.3cf9319f@pluto>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140805111330.3cf9319f@pluto>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 05 Aug, at 11:13:30AM, Bruno Prémont wrote:
> 
> I get at least to just before
>   status = efi_call_early(exit_boot_services, handle, key);
> in eboot.c on line 1310. A efi_printk inserted there is displayed.

This is worth pointing out in case you're unaware, but do you know that
it's not valid to call efi_printk() after ExitBootServices()? Doing so
will almost certainly cause your machine to fault.

-- 
Matt Fleming, Intel Open Source Technology Center
