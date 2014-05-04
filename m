Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014AbaEDEP0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 00:15:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60064 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbaEDEPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 00:15:25 -0400
Date: Sun, 4 May 2014 00:15:24 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Oleg Drokin <green@linuxhacker.ru>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: Re: [PATCH] staging/lustre: Replace jobid acquiring with per node
 setting
Message-ID: <20140504041524.GA3791@kroah.com>
References: <1398651712-5015-1-git-send-email-green@linuxhacker.ru>
 <20140503232945.GA15714@kroah.com>
 <AD08F6C5-1BAD-455B-9A09-1FFB8D2CA42E@linuxhacker.ru>
 <20140504023331.GB30871@kroah.com>
 <D18938B7-4D28-4312-8154-B5AE964ECEE4@linuxhacker.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D18938B7-4D28-4312-8154-B5AE964ECEE4@linuxhacker.ru>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 03, 2014 at 11:08:36PM -0400, Oleg Drokin wrote:
> Hello!
> 
> On May 3, 2014, at 10:33 PM, Greg Kroah-Hartman wrote:
> >> I don't think I saw complaints about proc files, the complaints I saw were mostly about
> >> reading env variables directly and the like so that was the focus of this patch.
> >> Did I miss some side discussion? Any pointers?
> > No, no side discussion, the proc files need to be removed / fixed before
> > the code can be merged to the "proper" part of the kernel tree.
> 
> So, what's broken about them then?
> It's not like there are no files in proc or that lustre-proc files are causing some
> sort of breakage (at least not anymore after that recent patch).

The rule of not adding new proc files that do not relate to processes,
has been around for over a decade now, since 2.6.0 came out.

Please use sysfs instead, you can put your files in /sys/fs/lustre/ and
keep them to "one-value-per-file" files and document them in
Documentation/ABI/

thanks,

greg k-h
