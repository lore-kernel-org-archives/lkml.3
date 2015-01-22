Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900AbbAVRfU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 12:35:20 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:34816 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451AbbAVRfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 12:35:18 -0500
Message-ID: <1421948107.30821.2.camel@haakon3.risingtidesystems.com>
Subject: Re: General protection fault in iscsi_rx_thread_pre_handler
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Gavin Guo <gavin.guo@canonical.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Thu, 22 Jan 2015 09:35:07 -0800
In-Reply-To: <CA+eFSM3H2zO7+bQBd7jO2sjB-MWjGNfGTeqDZDY_8_ruzj_Q_Q@mail.gmail.com>
References: <CA+eFSM1iir5QYsUALigzwcCPiqDGaNKBVq22unydN+-uTxZD2Q@mail.gmail.com>
	 <1421920228.7061.48.camel@haakon3.risingtidesystems.com>
	 <CA+eFSM3H2zO7+bQBd7jO2sjB-MWjGNfGTeqDZDY_8_ruzj_Q_Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2015-01-22 at 23:56 +0800, Gavin Guo wrote:
> Hi Nicolas,
> 
> On Thu, Jan 22, 2015 at 5:50 PM, Nicholas A. Bellinger
> <nab@linux-iscsi.org> wrote:
> > Hi Gavin,
> >
> > On Thu, 2015-01-22 at 06:38 +0800, Gavin Guo wrote:
> >> Hi all,
> >>
> >> The general protection fault screenshot is attached.
> >>
> >> Summary:
> >> The kernel is Ubuntu-3.13.0-39.66. I've done basic analysis and found
> >> the fault is in list_del of iscsi_del_ts_from_active_list. And it
> >> looks like deleting the iscsi_thread_set *ts two times. The point to
> >> delete including iscsi_get_ts_from_inactive_list, was also checked but
> >> still can't find the clue. Really appreciate if anyone can provide any
> >> idea on the bug.
> >>

<SNIP>

> >
> > Thanks for your detailed analysis.
> >
> > A similar bug was reported off-list some months back by a person using
> > iser-target + RoCE export on v3.12.y code.  Just to confirm, your
> > environment is using traditional iscsi-target + TCP export, right..?
> 
> I am sorry that I'm not an expert of the field and already google RoCE
> on the internet but still don't really know what RoCE is. However, I
> can provide the informations.  We used iscsiadm on the initiator side
> and lio_node and tcm_node commands to create the targets for
> connection. I think it should be normal  iscsi-target using TCP
> export.
> 

Yep, that would be traditional iscsi-target + TCP export.

> >
> > At the time, a different set of iser-target related changes ended up
> > avoiding this issue on his particular setup, so we thought it was likely
> > a race triggered by login failures specific to iser-target code.
> >
> > There was a untested patch (included inline below) to drop the legacy
> > active_ts_list usage all-together, but IIRC he was not able to reproduce
> > further so the patch didn't get picked up for mainline.
> >
> > If your able to reliability reproduce, please try with the following
> > patch and let us know your progress.
> 
> Thanks for your time reading the mail. I'll let you know the result.

Just curious, are you able to reliability reproduce this bug in a VM..?

--nab

