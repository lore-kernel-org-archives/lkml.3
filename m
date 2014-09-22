Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560AbaIVSRG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 14:17:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37043 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754462AbaIVSRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 14:17:04 -0400
Message-ID: <5420679D.3070406@canonical.com>
Date: Mon, 22 Sep 2014 13:17:01 -0500
From: Chris J Arges <chris.j.arges@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: linux-scsi@vget.kernel.org, bruce.lucas@mongodb.com,
        Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>,
        Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>,
        Sreekanth Reddy <sreekanth.reddy@avagotech.com>,
        Abhijit Mahajan <abhijit.mahajan@avagotech.com>,
        MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mptfusion: enable no_write_same in scsi_host_template
References: <1411408690-4766-1-git-send-email-chris.j.arges@canonical.com> <20140922180220.GA10166@infradead.org>
In-Reply-To: <20140922180220.GA10166@infradead.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 09/22/2014 01:02 PM, Christoph Hellwig wrote:
> On Mon, Sep 22, 2014 at 12:56:59PM -0500, Chris J Arges wrote:
>> When using a virtual SCSI disk in a VMWare VM if blkdev_issue_zeroout is used
>> data can be improperly zeroed out using the mptfusion driver. This patch
>> disables write_same for this driver which ensures that manual zeroing out
>> is used instead.
> 
> Does this affet real hardware or is it a VMware bug?  If it's just the
> latter we should simply blacklist VMware.
> 
I've only been able to reproduce this on VMWare. There is a pretty
straightforward reproducer in the BugLink if there is any interest in
verifying on hardware.

How would you recommending blacklisting only VMWare guests in this case?

Thanks,
--chris j arges
