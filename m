Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758029Ab3ENR5h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 13:57:37 -0400
Received: from longford.logfs.org ([213.229.74.203]:59184 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757462Ab3ENR5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 13:57:35 -0400
Date: Tue, 14 May 2013 12:29:39 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        target-devel <target-devel@vger.kernel.org>
Subject: Re: [PATCH 3/3] target: simplify target_wait_for_sess_cmds()
Message-ID: <20130514162939.GA32463@logfs.org>
References: <1368477007-25274-1-git-send-email-joern@logfs.org>
 <1368477007-25274-4-git-send-email-joern@logfs.org>
 <1368486003.4020.37.camel@haakon3.risingtidesystems.com>
 <20130513220057.GA24539@logfs.org>
 <1368500924.11576.16.camel@haakon3.risingtidesystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1368500924.11576.16.camel@haakon3.risingtidesystems.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 May 2013 20:08:44 -0700, Nicholas A. Bellinger wrote:
> On Mon, 2013-05-13 at 18:00 -0400, Jörn Engel wrote:
> > 
> > I agree that the overhead doesn't matter.  The msleep(100) spells this
> > out rather explicitly.  What does matter is that a) the patch retains
> > old behaviour with much simpler code and b) it fixes a race that kills
> > the machine.  I can live without a, but very much want to keep b. ;)
> 
> Fucking around with ->sess_cmd_lock during each loop of ->sess_cmd_list
> in target_wait_for_sess_cmds is not simpler code..

I could argue that fucking around with ->sess_cmd_lock during each
loop is simpler than the communication through cmd_wait_set and
cmd_wait_comp.  But simplicity is ultimately subjective and we can
argue all day.

 drivers/infiniband/ulp/srpt/ib_srpt.c  |    2 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c     |    2 +-
 drivers/target/target_core_transport.c |   64 +++++++++-----------------------
 include/target/target_core_base.h      |    2 -
 include/target/target_core_fabric.h    |    2 +-
 5 files changed, 20 insertions(+), 52 deletions(-)

But diffstat is reasonably objective.  Do you really want me to come
up with an alternative patch that adds code instead of removing it?

Jörn

--
Simplicity is prerequisite for reliability.
-- Edsger W. Dijkstra
