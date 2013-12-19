Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329Ab3LSPTP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:19:15 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:46258 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755083Ab3LSPTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:19:12 -0500
Message-ID: <1387466350.2210.5.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [PATCH 33/38] scsi: transport: add missing put_device call
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Levente Kurusa <levex@linux.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Mike Christie <michaelc@cs.wisc.edu>,
        open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org
Date: Thu, 19 Dec 2013 07:19:10 -0800
In-Reply-To: <1387465612-3673-34-git-send-email-levex@linux.com>
References: <1387465612-3673-33-git-send-email-levex@linux.com>
	 <1387465612-3673-34-git-send-email-levex@linux.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.8.5 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-12-19 at 16:06 +0100, Levente Kurusa wrote:
> This is required so that we give up the last reference to the device.

This isn't true.

> Remove the kfree() as well, because the put_device() will result in
> iscsi_endpoint_release being called and hence it will be kfree'd.

There's no real point to this patch.  The use case where we own the
device absolutely up until the point we hand out references is well
established and there are a number of destroy paths running through SCSI
code which don't go via refcounting and this is one of them.  They're
almost universally on error legs on device bring up as this one is.

James


