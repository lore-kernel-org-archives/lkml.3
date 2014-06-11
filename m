Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790AbaFKEzW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 00:55:22 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:49192 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995AbaFKEzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 00:55:19 -0400
Date: Wed, 11 Jun 2014 07:55:10 +0300
From: Johan Hedberg <johan.hedberg@intel.com>
To: Kamal Mostafa <kamal@canonical.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com, Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH 3.13 131/160] Bluetooth: Fix redundant encryption request
 for reauthentication
Message-ID: <20140611045510.GA28823@t440s.P-661HNU-F1>
References: <1402429600-20477-1-git-send-email-kamal@canonical.com>
 <1402429600-20477-132-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402429600-20477-132-git-send-email-kamal@canonical.com>
Organization: Intel Finland Oy - BIC 0357606-4 - PL 281, 00181 Helsinki
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jun 10, 2014, Kamal Mostafa wrote:
> 3.13.11.3 -stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Johan Hedberg <johan.hedberg@intel.com>
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
> Signed-off-by: Kamal Mostafa <kamal@canonical.com>
> ---
>  net/bluetooth/hci_conn.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)

This one has a regression reported against it:

https://bugzilla.kernel.org/show_bug.cgi?id=77541

The report also has a working fix for the issue which we'll be sending
to the stable trees (it's already in the Bluetooth subsystem tree). So
I'm not sure what the right way to proceed here: ignore this patch until
the other patch is available, apply this one and wait for the other one,
or just forget about both patches for the stable trees.

Johan
