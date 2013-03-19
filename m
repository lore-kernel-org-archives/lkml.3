Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757159Ab3CSA02 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 20:26:28 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:36835 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754346Ab3CSA00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 20:26:26 -0400
Date: Mon, 18 Mar 2013 17:27:42 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        linux-kernel@vger.kernel.org,
        target-devel <target-devel@vger.kernel.org>
Subject: Re: [PATCH] target: close target_put_sess_cmd() vs.
 core_tmr_abort_task() race
Message-ID: <20130319002742.GA11050@kroah.com>
References: <20130318222853.GA9358@logfs.org>
 <20130319000411.GA6406@kroah.com>
 <20130318225657.GA9685@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130318225657.GA9685@logfs.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 06:56:57PM -0400, Jörn Engel wrote:
> On Mon, 18 March 2013 17:04:11 -0700, Greg Kroah-Hartman wrote:
> > On Mon, Mar 18, 2013 at 06:28:53PM -0400, Jörn Engel wrote:
> > > It is possible for one thread to to take se_sess->sess_cmd_lock in
> > > core_tmr_abort_task() before taking a reference count on
> > > se_cmd->cmd_kref, while another thread in target_put_sess_cmd() drops
> > > se_cmd->cmd_kref before taking se_sess->sess_cmd_lock.
> > > 
> > > This introduces kref_put_and_lock() and uses it in
> > > target_put_sess_cmd() to close the race window.
> > 
> > We already have kref_put_mutex(), why not just call this
> > kref_put_spinlock()?
> 
> Back when I originally wrote this patch, kref_put_mutex() didn't exist
> yet.  So there is my evil predetermined plan to introduce random
> inconsistencies by being consistent with atomic_dec_and_lock()
> instead.

Don't be evil, leave that up to the professionals :)

> If you think this matters I can rename the function and resend.

Please do, it is good to name things correctly, when we have the chance.

greg k-h
