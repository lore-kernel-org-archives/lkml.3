Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886AbaAIQd1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 11:33:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60170 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751705AbaAIQdS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 11:33:18 -0500
Subject: Re: [Cluster-devel] Curious lockdep report
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: cluster-devel@redhat.com
In-Reply-To: <1389267839.2717.7.camel@menhir>
References: <1389267839.2717.7.camel@menhir>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Thu, 09 Jan 2014 16:32:45 +0000
Message-ID: <1389285165.2717.13.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 2014-01-09 at 11:43 +0000, Steven Whitehouse wrote:
> Hi,
> 
> I'm trying to track down the cause of the lockdep report which I've
> included below. It is a bit odd since it doesn't say which lock it
> refers to, although my suspicions are that it is the mapping's
> tree_lock. The other thing I know is that it goes away if I revert this
> patch:
> 
> https://git.kernel.org/cgit/linux/kernel/git/steve/gfs2-3.0-nmw.git/commit/?id=70d4ee94b370c5ef54d0870600f16bd92d18013c
> 
> However, it is not immediately obvious why, if the lockdep code is
> certain that there are no errors in the code, it needs to warn about
> missing annotation, nor is it clear what that annotation should be.
> 
> The reproducer is simple - just mount a gfs2 filesystem with the latest
> gfs2 -nmw tree and with lockdep turned on (can be local, doesn't need to
> be clustered) and do mkdir.
> 
> Any suggestions as to whats going wrong gratefully received :-)
> 
> Steve.
> 

Andy Price has solved the mystery... seems just to be some missing
initialisation for the address space in question. I'll get a patch sortd
out shortly,

Steve.



