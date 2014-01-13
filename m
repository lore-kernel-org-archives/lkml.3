Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751677AbaAMSnX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 13:43:23 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:48137 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbaAMSnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 13:43:21 -0500
Message-ID: <1389638711.5567.437.camel@haakon3.risingtidesystems.com>
Subject: Re: [PATCH 14/14] tcm_loop: Enable DIF/DIX modes in SCSI host LLD
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>,
        target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Sagi Grimberg <sagig@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>
Date: Mon, 13 Jan 2014 10:45:11 -0800
In-Reply-To: <yq1wqi7pmrd.fsf@sermon.lab.mkp.net>
References: <1389212157-14540-1-git-send-email-nab@daterainc.com>
	 <1389212157-14540-15-git-send-email-nab@daterainc.com>
	 <yq1wqi7pmrd.fsf@sermon.lab.mkp.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-01-10 at 16:09 -0500, Martin K. Petersen wrote:
> >>>>> "nab" == Nicholas A Bellinger <nab@daterainc.com> writes:
> 
> nab> This patch updates tcm_loop_driver_probe() to set protection
> nab> information using scsi_host_set_prot() and scsi_host_set_guard(),
> nab> which currently enabled all modes of DIF/DIX protection, minus DIF
> nab> TYPE0.
> 
> ITYM, DIX Type 0.

Yes.  Fixed up the commit message.

>  And ideally you'd have a way to choose between IP and
> T10 CRC for the guard type.
> 

Sure, this can be exposed at a tcm_loop configfs attribute that is
accessible after scsi_add_host() has been called, which I assume is OK
to do..

--nab

