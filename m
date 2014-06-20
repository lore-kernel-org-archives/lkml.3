Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966802AbaFTUXe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 16:23:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48853 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966015AbaFTUXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 16:23:32 -0400
Message-ID: <53A4981F.3060901@zytor.com>
Date: Fri, 20 Jun 2014 13:22:55 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Dave Hansen <dave@sr71.net>, linux-kernel@vger.kernel.org, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>, Dave Jones <davej@redhat.com>
Subject: Re: [RFC][PATCH 3/3] x86: make MP  a required-feature on 64-bit
References: <20140620161736.D6AC16FD@viggo.jf.intel.com> <20140620161740.BFB00798@viggo.jf.intel.com> <53A46008.5060509@zytor.com> <53A4619C.8020100@sr71.net> <53A46365.6090101@zytor.com> <20140620174345.GD11391@pd.tnic> <53A473AA.7050301@zytor.com> <20140620180523.GF11391@pd.tnic> <53A48356.5080109@zytor.com> <20140620200024.GJ11391@pd.tnic>
In-Reply-To: <20140620200024.GJ11391@pd.tnic>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2014 01:00 PM, Borislav Petkov wrote:
> On Fri, Jun 20, 2014 at 11:54:14AM -0700, H. Peter Anvin wrote:
>> No, it has to be cpu_has() -- the dynamic, CPU-specific version.
> 
> Ok, sry, but I have to ask: why cpu_has? Why not boot_cpu_has and thus
> static_cpu_has_safe?
> 

Because the whole point is testing each CPU and warn if it is unsuitable.

static-anything is just plain useless, because we test this once for
each CPU and patching a branch that we are never going to cross again is
just wasted effort.

	-hpa

