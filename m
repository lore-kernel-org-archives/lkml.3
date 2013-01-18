Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248Ab3ARANy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 19:13:54 -0500
Received: from mx2.parallels.com ([64.131.90.16]:54380 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753123Ab3ARANx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 19:13:53 -0500
Message-ID: <50F893D2.7080103@parallels.com>
Date: Thu, 17 Jan 2013 16:14:10 -0800
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-mm@kvack.org>, <xfs@oss.sgi.com>,
        Greg Thelen <gthelen@google.com>, Ying Han <yinghan@google.com>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH 09/19] list_lru: per-node list infrastructure
References: <1354058086-27937-1-git-send-email-david@fromorbit.com> <1354058086-27937-10-git-send-email-david@fromorbit.com> <50F6FDC8.5020909@parallels.com> <20130116225521.GF2498@dastard> <50F7475F.90609@parallels.com> <20130117042245.GG2498@dastard> <50F84118.7030608@parallels.com> <20130118001029.GK2498@dastard>
In-Reply-To: <20130118001029.GK2498@dastard>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [216.239.55.193]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2013 04:10 PM, Dave Chinner wrote:
> And then each object uses:
> 
> struct lru_item {
> 	struct list_head global_list;
> 	struct list_head memcg_list;
> }
by objects you mean dentries, inodes, and the such, right?
Would it be acceptable to you?

We've been of course doing our best to avoid increasing the size of the
objects, therefore this is something we've never mentioned. However, if
it would be acceptable from the fs POV, this would undoubtedly make our
life extremely easier.

