Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751843AbaANQbB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 11:31:01 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52333 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751437AbaANQa7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 11:30:59 -0500
Message-ID: <52D56627.9060802@zytor.com>
Date: Tue, 14 Jan 2014 08:30:31 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Kim Naru <kim.naru@amd.com>,
        Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>,
        Sherry Hurwitz <sherry.hurwitz@amd.com>
Subject: Re: [PATCH] x86, CPU, AMD: Add workaround for family 16h, erratum
 793
References: <20140114114133.GA31473@khazad-dum.debian.net> <20140114115547.GA29887@pd.tnic> <52D55468.6000000@zytor.com> <20140114153534.GE29865@pd.tnic> <20140114162722.GF29865@pd.tnic>
In-Reply-To: <20140114162722.GF29865@pd.tnic>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2014 08:27 AM, Borislav Petkov wrote:
> From: Borislav Petkov <bp@suse.de>
> 
> This adds the workaround for erratum 793 as a precaution in case not
> every BIOS implements it. This addresses CVE-2013-6885.
> 
> Signed-off-by: Borislav Petkov <bp@suse.de>

> +
> +#define MSR_AMD_LS_CFG	0xc0011020
> +	/* F16h, models 00h-0fh, erratum 793 */
> +	if (c->x86 == 0x16 && c->x86_model <= 0xf) {

Please put MSR_AMD_LS_CFG in msr-index.h or at least at the top of the
file, and put the CVE reference in the comment.

Otherwise, looks good.

	-hpa


