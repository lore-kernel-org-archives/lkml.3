Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256Ab3EODEb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 23:04:31 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:33733 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755764Ab3EODE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 23:04:29 -0400
Message-ID: <1368587247.9012.34.camel@haakon3.risingtidesystems.com>
Subject: Re: [PATCH 2/3] target: close target_put_sess_cmd() vs.
 core_tmr_abort_task() race v5
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Joern Engel <joern@logfs.org>, linux-kernel@vger.kernel.org,
        target-devel <target-devel@vger.kernel.org>
Date: Tue, 14 May 2013 20:07:27 -0700
In-Reply-To: <20130514190451.GA2907@kroah.com>
References: <1368477007-25274-1-git-send-email-joern@logfs.org>
	 <1368477007-25274-3-git-send-email-joern@logfs.org>
	 <20130514190451.GA2907@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-05-14 at 15:04 -0400, Greg Kroah-Hartman wrote:
> On Mon, May 13, 2013 at 04:30:06PM -0400, Joern Engel wrote:
> > It is possible for one thread to to take se_sess->sess_cmd_lock in
> > core_tmr_abort_task() before taking a reference count on
> > se_cmd->cmd_kref, while another thread in target_put_sess_cmd() drops
> > se_cmd->cmd_kref before taking se_sess->sess_cmd_lock.
> > 
> > This introduces kref_put_spinlock_irqsave() and uses it in
> > target_put_sess_cmd() to close the race window.
> > 
> > Signed-off-by: Joern Engel <joern@logfs.org>
> 
> For the kref.h part, please feel free to add:
> 
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Applied to target-pending/queue

Since this fixes a real long-standing bug within tcm_qla2xxx code, I'm
adding a CC' to stable as well.

Thanks Joern + Greg-KH!

--nab


