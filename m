Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141AbaKTO5g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 09:57:36 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:58467 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969AbaKTO5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 09:57:35 -0500
Date: Thu, 20 Nov 2014 16:57:26 +0200
From: Johan Hedberg <johan.hedberg@gmail.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Steven Walter <stevenrwalter@gmail.com>,
        "Gustavo F. Padovan" <gustavo@padovan.org>,
        BlueZ development <linux-bluetooth@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] Bluetooth: automatically flushable packets aren't
 allowed on LE links
Message-ID: <20141120145726.GA11947@t440s.P-661HNU-F1>
Mail-Followup-To: Marcel Holtmann <marcel@holtmann.org>,
	Steven Walter <stevenrwalter@gmail.com>,
	"Gustavo F. Padovan" <gustavo@padovan.org>,
	BlueZ development <linux-bluetooth@vger.kernel.org>,
	linux-kernel@vger.kernel.org
References: <1416419951-27659-1-git-send-email-stevenrwalter@gmail.com>
 <20141120113813.GA23288@t440s.lan>
 <80321467-10AB-489E-A47E-44B0ECEE4BE1@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <80321467-10AB-489E-A47E-44B0ECEE4BE1@holtmann.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marcel,

On Thu, Nov 20, 2014, Marcel Holtmann wrote:
> > static u16 get_acl_flags(struct hci_conn *hcon, struct l2cap_chan *chan)
> > {
> 
> If we do it with a helper functions, then it should only provide the
> l2cap_chan since we can get the hci_conn from there.

One of the places it'd get called from (l2cap_send_cmd)  doesn't have a
l2cap_chan context at all which is why I split this into one mandatory
(hci_conn) and another optoinal (l2cap_chan) parameter.

Anyway, if you're happy with having this inline with a code comment
explaining the (rather complex) if-statement then I'm fine with that
too.

Johan
