Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480AbaETRFm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 13:05:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:47489 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750808AbaETRFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 13:05:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,875,1392192000"; 
   d="scan'208";a="514921011"
Date: Tue, 20 May 2014 10:04:49 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Marek =?utf-8?B?T2zFocOhaw==?= <maraeo@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        "Deucher, Alexander" <alexander.deucher@amd.com>,
        akpm@linux-foundation.org, dri-devel <dri-devel@lists.freedesktop.org>
Subject: Re: [PATCH 7/8] radeon: Out of line radeon_get_ib_value
Message-ID: <20140520170449.GK19657@tassilo.jf.intel.com>
References: <1400276595-6965-1-git-send-email-andi@firstfloor.org>
 <1400276595-6965-8-git-send-email-andi@firstfloor.org>
 <CAAxE2A4YvKRNMu6ogYOX2zE2=N1Q6hd1c0niB3jf9f3P8rwoRw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAxE2A4YvKRNMu6ogYOX2zE2=N1Q6hd1c0niB3jf9f3P8rwoRw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 06:16:48PM +0200, Marek Olšák wrote:
> I think the function should stay in the header file. It's used in
> performance-critical code, so we want it to be inlined.

This doesn't make any sense. If it's talking to the hardware it will
be dominated by the cache misses.

-Andi
