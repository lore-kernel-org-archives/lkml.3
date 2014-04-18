Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751237AbaDREtW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 00:49:22 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35146 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbaDREtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 00:49:20 -0400
Date: Fri, 18 Apr 2014 05:49:04 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andi Kleen <andi@firstfloor.org>
Cc: mmarek@suse.cz, hpa@zytor.com, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH] Kbuild, lto: Avoid reported warning with strtoul
Message-ID: <20140418044904.GM18016@ZenIV.linux.org.uk>
References: <1397795756-23283-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397795756-23283-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2014 at 06:35:56AM +0200, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Apparently someone's C library declares strtoul with warn_unused_result.
> Cast to void to avoid the warning. Error handling is not useful here.

Umm...  Since we don't give a fsck for the value, isn't that simply
	
	char *p = strchr(s, '.');
	if (p) {
		size_t m = strspn(p + 1, "0123456789");
		if (m > 0 && (p[m + 1] == '.' || p[m + 1] == '\0'))
			*p = '\0';
	}
