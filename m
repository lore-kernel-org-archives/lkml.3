Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573Ab3F1P42 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 11:56:28 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:57045 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755534Ab3F1P41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 11:56:27 -0400
Date: Fri, 28 Jun 2013 11:56:26 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: William Gulland <wgulland@google.com>
cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Lan Tianyu <tianyu.lan@intel.com>, Ming Lei <ming.lei@canonical.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: Clear both buffers when clearing a control transfer
 TT buffer.
In-Reply-To: <1372374620-11790-1-git-send-email-wgulland@google.com>
Message-ID: <Pine.LNX.4.44L0.1306281150540.1047-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Jun 2013, William Gulland wrote:

>     Control transfers have both IN and OUT (or SETUP) packets, so when
>     clearing TT buffers for a control transfer it's necessary to send
>     two HUB_CLEAR_TT_BUFFER requests to the hub.

What makes you think this is necessary?  Have you found any hardware 
that requires this?

Although the USB spec doesn't say much about Clear-TT-Buffer requests,
the text in section 11.17.1 and Figure 11-47 seems to indicate that a
second Clear-TT-Buffer shouldn't be needed.  The spec says that TT
buffers are matched based on the device address, endpoint number, and
endpoint direction -- but the direction is used only for bulk
endpoints, not for control endpoints.

In particular, a control endpoint uses only one TT buffer for both the
IN and OUT directions.  So I don't think two Clear-TT-Buffers are
needed.

Alan Stern

