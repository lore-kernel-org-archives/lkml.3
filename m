Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759396Ab3JORCq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 13:02:46 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:58644 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758955Ab3JORCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 13:02:44 -0400
Date: Tue, 15 Oct 2013 13:02:43 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Vishal Annapurve <vannapurve@nvidia.com>
cc: Ming Lei <tom.leiming@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>
Subject: RE: [PATCH] usb-storage: scsiglue: Changing the command result
In-Reply-To: <113ACA888B71994BB56E5CF3704953486D65F41133@BGMAIL02.nvidia.com>
Message-ID: <Pine.LNX.4.44L0.1310151258560.1377-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Oct 2013, Vishal Annapurve wrote:

> Hi Alan,
> 
> This issue seems more related to the devices using SCSI protocol and the
> changes otherwise will be at more places giving the same end result.
> 
> I think as the comment says over the command_abort function,
> intentional result change should only happen in case of timeout.

usb-storage doesn't know _why_ a command was aborted; it knows only 
that the abort occurred.

If you look carefully at the code, you'll see that the result is set to 
DID_ABORT only when the US_FLIDX_TIMED_OUT bit is set, and this bit 
gets set only when a SCSI abort occurs.

Alan Stern

