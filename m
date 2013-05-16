Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389Ab3EPLwb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 07:52:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35517 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752215Ab3EPLw3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 07:52:29 -0400
Date: Thu, 16 May 2013 21:52:12 +1000
From: Dave Chinner <dchinner@redhat.com>
To: Oskar Andero <oskar.andero@sonymobile.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Radovan Lekanovic <radovan.lekanovic@sonymobile.com>,
        David Rientjes <rientjes@google.com>,
        Glauber Costa <glommer@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] mm: vmscan: handle any negative return value from
 scan_objects
Message-ID: <20130516115212.GC11167@devil.localdomain>
References: <1368693736-15486-1-git-send-email-oskar.andero@sonymobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368693736-15486-1-git-send-email-oskar.andero@sonymobile.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 16, 2013 at 10:42:16AM +0200, Oskar Andero wrote:
> The shrinkers must return -1 to indicate that it is busy. Instead, treat
> any negative value as busy.

Why? The API defines return condition for aborting a scan and gives
a specific value for doing that. i.e. explain why should change the
API to over-specify the 'abort scan" return value like this.

FWIW, using "any" negative number for "abort scan" is a bad API
design decision. It means that in future we can't introduce
different negative return values in the API if we have a new to.
i.e. each specific negative return value needs to have the potential
for defining a different behaviour. 

So if any change needs to be made, it is to change the -1 return
value to an enum and have the shrinkers return that enum when they
want an abort.

-Dave.
-- 
Dave Chinner
dchinner@redhat.com
