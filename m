Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757491Ab3BFP47 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 10:56:59 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:33062 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757330Ab3BFP44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 10:56:56 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: George Spelvin <linux@horizon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rodolfo Giometti <giometti@enneenne.com>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 0/4] tty, pps: decouple pps
Date: Wed,  6 Feb 2013 10:55:12 -0500
Message-Id: <1360166116-30797-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <20130204010303.24971.qmail@science.horizon.com>
References: <20130204010303.24971.qmail@science.horizon.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The recent breakage of the N_PPS line discipline is due to the tight coupling
pps has created in the tty subsystem. Since the extension of the line discipline
api to accomodate the needs of pps, this level of coupling is unnecessary and
undesirable.

Peter Hurley (4):
  pps: Decouple N_PPS from N_TTY
  pps: Don't crash the machine when exiting will do
  pps: Use lookup list to reduce ldisc coupling
  tty: Remove ancient hardpps()

 drivers/pps/clients/pps-ldisc.c     | 76 ++++++++++++++++++++++++++++++++-----
 drivers/staging/speakup/selection.c |  1 +
 drivers/tty/amiserial.c             |  5 ---
 drivers/tty/n_tty.c                 |  3 +-
 drivers/tty/serial/serial_core.c    | 23 ++++-------
 drivers/tty/tty_buffer.c            |  1 +
 include/linux/serial_core.h         |  1 -
 include/linux/tty_ldisc.h           | 11 ++----
 8 files changed, 83 insertions(+), 38 deletions(-)

-- 
1.8.1.2

