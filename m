Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757470Ab3ETP72 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 11:59:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57776 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757021Ab3ETP70 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 11:59:26 -0400
Message-ID: <519A483F.7070400@zytor.com>
Date: Mon, 20 May 2013 08:58:55 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        =?ISO-8859-1?Q?Fernando_Luis_V=E1zquez_Cao?= 
	<fernando@oss.ntt.co.jp>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, x86@kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Revert "x86-64, init: Do not set NX bits on non-NX capable
 hardware"
References: <20130514160108.GA5055@dhcp22.suse.cz> <1369062192-7066-1-git-send-email-mhocko@suse.cz>
In-Reply-To: <1369062192-7066-1-git-send-email-mhocko@suse.cz>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2013 08:03 AM, Michal Hocko wrote:
> This reverts commit 78d77df71510a96e042de7ba6dbd7998103642cb because
> it breaks resume from suspend to ram. Git bisect pointed to this patch
> and the revert fixes the problem.
> 
> There are no error messages neither during suspend not on resume when
> the machine simply starts booting as if it wasn't suspended in RAM at
> all.

Machine details and configuration, please?  This is one of a series of
extremely bizarre suspend to RAM failures we are trying to make sense
of... in this case, it means that somehow switching from setting the NX
bit conditionally to unconditionally somehow fixes suspend to RAM!

Needless to say, this is not just bizarre, this is extremely disturbing.

	-hpa


