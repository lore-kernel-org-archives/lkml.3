Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751863AbaKDHk2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 02:40:28 -0500
Received: from mail.emea.novell.com ([130.57.118.101]:34553 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbaKDHk0 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Tue, 4 Nov 2014 02:40:26 -0500
Message-Id: <545890F40200007800044A31@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.1 
Date: Tue, 04 Nov 2014 07:40:20 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Dave Chinner" <david@fromorbit.com>
Cc: <xfs@oss.sgi.com>, "Jan Kara" <jack@suse.cz>,
        <linux-kernel@vger.kernel.org>
Subject: Re: your patch "mm: Remove false WARN_ON from
 pagecache_isize_extended()"
References: <5457BE390200007800044838@mail.emea.novell.com>
 <20141103221849.GB23575@dastard>
In-Reply-To: <20141103221849.GB23575@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 03.11.14 at 23:18, <david@fromorbit.com> wrote:
> On Mon, Nov 03, 2014 at 04:41:13PM +0000, Jan Beulich wrote:
>> having run into that warning too, I looked into it a little, and now
>> having found that patch am pretty uncertain: Both truncate_setsize()
>> and pagecache_isize_extended() document that they want to be
>> called with i_mutex held, so removing the WARN_ON() alone seems
>> either incomplete or wrong. What I found to work without violating
>> this documented requirement is the patch below.
> 
> Or, just perhaps, the comments are wrong....

Right - that's what I was suggesting with the option of the patch
being incomplete (rather than just removing the WARN_ON() it
should also remove the respective comments then).

Jan

