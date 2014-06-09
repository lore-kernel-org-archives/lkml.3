Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933599AbaFINdP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 09:33:15 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:63001 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932657AbaFINdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 09:33:12 -0400
Date: Mon, 9 Jun 2014 16:33:02 +0300
From: Johan Hedberg <johan.hedberg@intel.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH 3.12 064/146] Bluetooth: Fix redundant encryption request
 for reauthentication
Message-ID: <20140609133302.GA10377@t440s.lan>
References: <cover.1402303820.git.jslaby@suse.cz>
 <b4afe9c6a39ffb4011c025ea6ecc4a99111beedd.1402303821.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b4afe9c6a39ffb4011c025ea6ecc4a99111beedd.1402303821.git.jslaby@suse.cz>
Organization: Intel Finland Oy - BIC 0357606-4 - PL 281, 00181 Helsinki
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jun 09, 2014, Jiri Slaby wrote:
> 3.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ===============
> 
> commit 09da1f3463eb81d59685df723b1c5950b7570340 upstream.
> 
> When we're performing reauthentication (in order to elevate the
> security level from an unauthenticated key to an authenticated one) we
> do not need to issue any encryption command once authentication
> completes. Since the trigger for the encryption HCI command is the
> ENCRYPT_PEND flag this flag should not be set in this scenario.
> Instead, the REAUTH_PEND flag takes care of all necessary steps for
> reauthentication.
> 
> Signed-off-by: Johan Hedberg <johan.hedberg@intel.com>
> Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> ---
>  net/bluetooth/hci_conn.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)

This one seems to be causing a regression, so it's probably best to keep
it out of stable trees for now:

https://bugzilla.kernel.org/show_bug.cgi?id=77541

Johan
