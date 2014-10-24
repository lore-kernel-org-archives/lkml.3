Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354AbaJXIJ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 04:09:29 -0400
Received: from rrzmta2.uni-regensburg.de ([194.94.155.52]:44474 "EHLO
	rrzmta2.uni-regensburg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbaJXIJZ convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:1:1>);
	Fri, 24 Oct 2014 04:09:25 -0400
Message-Id: <544A2550020000A100017826@gwsmtp1.uni-regensburg.de>
X-Mailer: Novell GroupWise Internet Agent 14.0.1 
Date: Fri, 24 Oct 2014 10:09:20 +0200
From: "Ulrich Windl" <Ulrich.Windl@rz.uni-regensburg.de>
To: <linux-kernel@vger.kernel.org>
Subject: RFE: kernel message "rport-2:0-10: blocked FC remote port time
 out: removing rport"
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I'd like to point out that the following Fibre CHannel error message is of little practical use, because it lacks essential information:

kernel: [   68.406963]  rport-2:0-10: blocked FC remote port time out: removing rport
(Seen in the current SLES11 SP3 kernel 3.0.101-0.40-default)

As the logical port is removed (as the message says), you cannot find out what device (i.e. WWN) the problem message refers to.

For existing ports in /sys/class/fc_remote_ports/ you can query port_id, port_name, port_state, etc. But once the port is removed, you cannot get any information about it.

In a real environment, you cannot easily guess where the problem might be, especially as there is no other message about "rport-2:0-10" before it's being removed.

I suggest to include the port ID (you can get the HBA WWN from that) and port WWN (the target device port) in the erro message if possible.

Regards,
Ulrich Windl


