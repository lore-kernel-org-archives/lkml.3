Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451Ab3DUWgA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 18:36:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43789 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752874Ab3DUWgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 18:36:00 -0400
Message-ID: <517469BD.3060406@zytor.com>
Date: Sun, 21 Apr 2013 15:35:41 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] x86: Fix AMD K6 indirect call check v2
References: <1366562995-20530-1-git-send-email-andi@firstfloor.org> <51741CB2.3090209@zytor.com> <20130421174456.GA4559@pd.tnic>
In-Reply-To: <20130421174456.GA4559@pd.tnic>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/2013 10:44 AM, Borislav Petkov wrote:
> 
> But I have hard time understanding what that test with the 10^6 loop
> iterations is supposed to achieve. And what makes sure that the RDTSCs
> don't get reordered? Or maybe K6 wasn't reordering that aggressively...
> 
> Erratum says "unpredictable system behavior" but it seems it wasn't that
> unpredictable after all - otherwise the fix would've been "HLT" right
> then and there. :)
> 

Looks like it is just trying to sense the bug... but then it doesn't
actually do anything about it.  At least it should taint the kernel.

	-hpa


