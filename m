Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756261Ab3AaWCN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 17:02:13 -0500
Received: from mail-ob0-f182.google.com ([209.85.214.182]:54939 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755079Ab3AaWCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 17:02:08 -0500
MIME-Version: 1.0
In-Reply-To: <1356263388.15812.7.camel@dabdike.home>
References: <1356064540-17414-1-git-send-email-dbasehore@chromium.org>
	<1356263388.15812.7.camel@dabdike.home>
Date: Thu, 31 Jan 2013 14:02:07 -0800
X-Google-Sender-Auth: ODq-rmYQrzjPy8-yDhkR8EU004w
Message-ID: <CAGAzgsoa4XRsVz8UKVm-qZKmWNq+vsge-BBZewzmrRHSQm0k=A@mail.gmail.com>
Subject: Re: [PATCH 1/2] don't wait on disk to start on resume
From: "dbasehore ." <dbasehore@chromium.org>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: jgarzik@pobox.com, linux-ide@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Resending message as plain text so it's tracked through vger lists)

I didn't notice the other call to async_synchronize_full, I'll remove that one.

I split up the functionality of sd_start_stop_device to ensure that
the command to start the disk was sent before resume was completed.
For now, it's open coded, but that could be changed if I make
additions are made to scsi_lib.c to allow us to return immediately
after scheduling the command.
