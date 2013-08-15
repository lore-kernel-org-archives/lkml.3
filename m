Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758568Ab3HOPOb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 11:14:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:31373 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755151Ab3HOPO2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 11:14:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,885,1367996400"; 
   d="scan'208";a="381430010"
Message-ID: <520CF04D.7020002@linux.intel.com>
Date: Thu, 15 Aug 2013 08:14:21 -0700
From: Dave Hansen <dave.hansen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>, Andy Lutomirski <luto@amacapital.net>,
        linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
        linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>, david@fromorbit.com,
        Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: page fault scalability (ext3, ext4, xfs)
References: <520BB9EF.5020308@linux.intel.com> <20130814194359.GA22316@thunk.org> <520BED7A.4000903@intel.com> <20130814230648.GD22316@thunk.org> <CALCETrVaRQ3WQ5++Uu_0JTaVnjUugAaAhqQK__7r5YWvLxpAhw@mail.gmail.com> <20130815011101.GA3572@thunk.org>
In-Reply-To: <20130815011101.GA3572@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2013 06:11 PM, Theodore Ts'o wrote:
> The point is that if the goal is to measure page fault scalability, we
> shouldn't have this other stuff happening as the same time as the page
> fault workload.

will-it-scale does several different tests probing at different parts of
the fault path:

https://www.sr71.net/~dave/intel/willitscale/systems/bigbox/3.11.0-rc2-dirty/foo.html

It does that both for process and threaded workloads which lets it get
pretty good coverage of different areas of code.

I only posted data from half of one of these tests here because it was
the only one that I found that both had noticeable overhead in the
filesystem code.  It also showed substantial, consistent, and measurable
deltas between the different filesystems.
