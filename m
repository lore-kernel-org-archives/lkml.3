Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719Ab3BDO16 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 09:27:58 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:33433 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755670Ab3BDO1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 09:27:54 -0500
Message-ID: <510FC560.6020002@intel.com>
Date: Mon, 04 Feb 2013 22:27:44 +0800
From: Aaron Lu <aaron.lu@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: "dbasehore ." <dbasehore@chromium.org>
CC: Alan Stern <stern@rowland.harvard.edu>,
        James Bottomley <JBottomley@parallels.com>,
        Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        SCSI development list <linux-scsi@vger.kernel.org>,
        Linux-pm mailing list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH 1/2] don't wait on disk to start on resume
References: <Pine.LNX.4.44L0.1302021003390.25931-100000@netrider.rowland.org> <510E025A.9000103@intel.com> <CAGAzgsqMhO9nppbooY5E2H5MXZ6VcCXR-P8S=nD7_7QJYrtmdw@mail.gmail.com>
In-Reply-To: <CAGAzgsqMhO9nppbooY5E2H5MXZ6VcCXR-P8S=nD7_7QJYrtmdw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/2013 08:07 AM, dbasehore . wrote:
> On the topic that we do a fast return for both scsi and ata. Now I
> don't remember everything about this (and correct me if I'm wrong)
> since I figured this out a few months ago.
>
> There are some dependencies that scsi has on the resume path of ata. I
> think it's that before we can send the command to spin up the disk, we
> need to wait for the ata host controller to come up. As Aaron Lu
> pointed out, it takes seconds for the ata port to resume. On the hand,

I just did some more recording, the result is:
host controller takes 1ms or less to resume;
port reset takes the most time, almost the same as the whole port resume
callback, 2-4 seconds;
sd resume callback takes 16ms.

So for ata disks, the most time consuming part is in port's reset
routine, which is executed in port's resume callback.

-Aaron

