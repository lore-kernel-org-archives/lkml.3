Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776Ab3KMB5V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 20:57:21 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:39240 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754491Ab3KMB5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 20:57:13 -0500
Message-ID: <1384307830.2248.17.camel@dabdike>
Subject: Re: [PATCH] scsi: avoid use of reclaimed reference
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: David Decotigny <decot@googlers.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 12 Nov 2013 17:57:10 -0800
In-Reply-To: <643cda2192c25962f37c8bba65e22f70a57167d0.1384304973.git.decot@googlers.com>
References: <cover.1384304973.git.decot@googlers.com>
	 <643cda2192c25962f37c8bba65e22f70a57167d0.1384304973.git.decot@googlers.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.8.5 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-11-12 at 17:10 -0800, David Decotigny wrote:
> This patch avoids to use an object after it was potentially reclaimed
> by scsi_device_put().

The analysis is wrong, I'm afraid.  __scsi_remove_device() does the
final put for devices that are being destroyed.  If the device isn't in
the created state, then it's long lived and nothing in the report lun
scan does the final put.

James


