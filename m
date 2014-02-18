Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097AbaBRSuL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 13:50:11 -0500
Received: from one.firstfloor.org ([193.170.194.197]:55378 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbaBRSuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 13:50:10 -0500
Date: Tue, 18 Feb 2014 19:50:08 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        sam@ravnborg.org, x86@kernel.org, linux-kbuild@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/6] kbuild: Remove relocations from kallsyms table
Message-ID: <20140218185007.GB22728@two.firstfloor.org>
References: <1392733470-8228-1-git-send-email-andi@firstfloor.org>
 <1392733470-8228-2-git-send-email-andi@firstfloor.org>
 <53036E26.1040701@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53036E26.1040701@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 06:28:54AM -0800, H. Peter Anvin wrote:
> On 02/18/2014 06:24 AM, Andi Kleen wrote:
> > From: Andi Kleen <ak@linux.intel.com>
> > 
> > Remove the ELF relocations from the kallsyms_address[] table.
> > Instead we just store offsets to _text and relocate that while
> > accessing the kallsyms table. This is done with a new
> > kallsyms_offsets[] table. With these changes .tmp_kallsyms*.o
> > becomes relocation free.
> > 
> > In theory this would also allow to shrink the kallsyms table
> > on 64bit by using offsets.
> > 
> 
> Why not do that, then?

I tried it once, but it didn't boot for some reason. Didn't have
time to track it down so I removed it. Could be done as followon
work.

-Andi
