Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932149Ab3ETN4U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 09:56:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44579 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932087Ab3ETN4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 09:56:17 -0400
Date: Mon, 20 May 2013 06:56:35 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Oskar Andero <oskar.andero@sonymobile.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Radovan Lekanovic <radovan.lekanovic@sonymobile.com>,
        David Rientjes <rientjes@google.com>,
        Glauber Costa <glommer@openvz.org>, Dave Chinner <dchinner@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH] mm: vmscan: add BUG_ON on illegal return values from
 scan_objects
Message-ID: <20130520135635.GA18693@kroah.com>
References: <1369041267-26424-1-git-send-email-oskar.andero@sonymobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369041267-26424-1-git-send-email-oskar.andero@sonymobile.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 20, 2013 at 11:14:27AM +0200, Oskar Andero wrote:
> Add a BUG_ON to catch any illegal value from the shrinkers. This fixes a
> potential bug if scan_objects returns a negative other than -1, which
> would lead to undefined behaviour.

So it's better to crash a machine and keep anyone from using it?
Instead of recovering from an error you found?  Not good.

greg k-h
