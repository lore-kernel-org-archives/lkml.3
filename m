Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932802Ab3CSAVn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 20:21:43 -0400
Received: from longford.logfs.org ([213.229.74.203]:58715 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215Ab3CSAVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 20:21:41 -0400
X-Greylist: delayed 1683 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Mar 2013 20:21:41 EDT
Date: Mon, 18 Mar 2013 18:56:57 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        linux-kernel@vger.kernel.org,
        target-devel <target-devel@vger.kernel.org>
Subject: Re: [PATCH] target: close target_put_sess_cmd() vs.
 core_tmr_abort_task() race
Message-ID: <20130318225657.GA9685@logfs.org>
References: <20130318222853.GA9358@logfs.org>
 <20130319000411.GA6406@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130319000411.GA6406@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 March 2013 17:04:11 -0700, Greg Kroah-Hartman wrote:
> On Mon, Mar 18, 2013 at 06:28:53PM -0400, Jörn Engel wrote:
> > It is possible for one thread to to take se_sess->sess_cmd_lock in
> > core_tmr_abort_task() before taking a reference count on
> > se_cmd->cmd_kref, while another thread in target_put_sess_cmd() drops
> > se_cmd->cmd_kref before taking se_sess->sess_cmd_lock.
> > 
> > This introduces kref_put_and_lock() and uses it in
> > target_put_sess_cmd() to close the race window.
> 
> We already have kref_put_mutex(), why not just call this
> kref_put_spinlock()?

Back when I originally wrote this patch, kref_put_mutex() didn't exist
yet.  So there is my evil predetermined plan to introduce random
inconsistencies by being consistent with atomic_dec_and_lock()
instead.

If you think this matters I can rename the function and resend.

Jörn

--
Computer system analysis is like child-rearing; you can do grievous damage,
but you cannot ensure success."
-- Tom DeMarco
