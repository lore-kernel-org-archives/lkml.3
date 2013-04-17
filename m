Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966365Ab3DQNfJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 09:35:09 -0400
Received: from plane.gmane.org ([80.91.229.3]:35840 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966186Ab3DQNfH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 09:35:07 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Juno Krahn <Juno.Krahn@gmail.com>
Subject: Re: WRITE SAME failed in recent kernels
Date: Wed, 17 Apr 2013 13:30:34 +0000 (UTC)
Message-ID: <loom.20130417T151925-309@post.gmane.org>
References: <516A4E2D.30203@molgaard.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 157.98.106.213 (Mozilla/5.0 (X11; Linux x86_64; rv:18.0) Gecko/20100101 Firefox/18.0)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sune Mølgaard <sune <at> molgaard.org> writes:

> 
> Dear All,
> 
> In the setting of an SSD and an HDD connected to a HighPoint RocketRAID
> 620, I am seeing quite a number of log messages such as:
> 
> Apr 14 06:02:30 jekaterina kernel: [  952.460537] sd 8:0:1:0: [sde]
> Unhandled error code
> Apr 14 06:02:30 jekaterina kernel: [  952.460542] sd 8:0:1:0: [sde]
> Apr 14 06:02:30 jekaterina kernel: [  952.460544] Result: hostbyte=0x05
> driverbyte=0x05
> Apr 14 06:02:30 jekaterina kernel: [  952.460546] sd 8:0:1:0: [sde] CDB:
> Apr 14 06:02:30 jekaterina kernel: [  952.460548] cdb[0]=0x41: 41 00 a8
> c6 fb 78 00 00 18 00
> Apr 14 06:02:30 jekaterina kernel: [  952.460557] end_request: I/O
> error, dev sde, sector 2831612792
> Apr 14 06:02:30 jekaterina kernel: [  952.460566] sde1: WRITE SAME
> failed. Manually zeroing.
> 
> with sde being the regular HDD.
> 
> Now, I am aware that the HighPoint driver, rr62x, isn't part of
> mainline, and thus I have contacted HighPoint Technologies as well, but
> I would like to know how to ascertain whether this is, indeed, a problem
> with their driver, or if it's a problem pertaining to the kernel itself.
> 
> Any help, really, is much appreciated, even if it amounts to "HighPoint
> is to blame", as I would then have that on higher authority than myself.
> 
> Best regards,
> 
> Sune Mølgaard
> 

I have this same problem, resulting in many thousands of kernel messages.
Since WRITE SAME support is not essential, it makes sense that the block
driver should disable this feature when it results in an error.

I am also looking into how the HighPoint driver can be patched to prevent
the block driver from using WRITE SAME. However, it seems probable that
other situations will arise due to driver or hardware issues, and it makes
sense to avoid a potential for a flood of repeated kernel messages,
especially for an optional feature.

Juno Krahn

