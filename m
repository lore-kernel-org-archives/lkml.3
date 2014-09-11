Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470AbaIKNgj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 09:36:39 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:16233 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753400AbaIKNgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 09:36:37 -0400
X-AuditID: cbfee61a-f79e46d00000134f-71-5411a563312a
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org
Subject: Re: [PATCH RESEND 0/1] AHCI: Optimize interrupt processing
Date: Thu, 11 Sep 2014 15:36:31 +0200
Message-id: <4127129.ClfhyhZXo5@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <20140911124248.GA18490@dhcp-27-160.brq.redhat.com>
References: <cover.1369155164.git.agordeev@redhat.com>
 <20130521235003.GE6985@mtj.dyndns.org>
 <20140911124248.GA18490@dhcp-27-160.brq.redhat.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsVy+t9jAd3kpYIhBqvuGlu8fH6azeLYjkdM
	Fpd3zWGz+LX8KKMDi8emVZ1sHu/3XWXz+LxJLoA5issmJTUnsyy1SN8ugSvj5+1W1oKvHBUv
	j5xnamCcwN7FyMkhIWAi8ezSayhbTOLCvfVsXYxcHEICixglrnRMZ4FwWpgk1rTvYgWpYhOw
	kpjYvooRxBYR0JZo2/wNrJtZIEJi97HJYDXCAs4S8//vZwKxWQRUJa7sPMEMYvMKaEq8+zYR
	rFdUwFNix/aVbCA2p4CDxP7e/awQy6YySryd0cQG0SAo8WPyPRaIBfIS+/ZPZYWwtSTW7zzO
	NIFRYBaSsllIymYhKVvAyLyKUTS1ILmgOCk911CvODG3uDQvXS85P3cTIzhsn0ntYFzZYHGI
	UYCDUYmHt4JFMESINbGsuDL3EKMEB7OSCK/zQqAQb0piZVVqUX58UWlOavEhRmkOFiVx3gOt
	1oFCAumJJanZqakFqUUwWSYOTqkGRs9e82V+lUphlZ7/2i5onK6eqqTfsbCatf1T3Jz7/CxT
	6kWV5zM1rWY4yKG2qt3d+BOr1bbzDgoPtp3Oc+0P3XXZ9IHc/a3Fn5Pul/U9YDyydlpds1vB
	i91ZvLzh4fNuOXtLuy9et4+9l7sshX2apt/i85fYYmZv/mpUv6ukR+L6z5QA+fW3lFiKMxIN
	tZiLihMBSLo7KlcCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Thursday, September 11, 2014 02:42:49 PM Alexander Gordeev wrote:

> The numbers are taken by running 'dd if=/dev/sd{a,b} of=/dev/null'
> in parallel. All time values are in us.
> 
> Before this update host lock average holdtime was 2.45 and
> average waittime was 1.24. After the update average holdtime
> dropped to 0.29 (about eight times) while average waittime
> decreased to 0.58 (about two times).
> 
> Also, port events are handled with local interrupts enabled
> and compete on individual per-port locks with average holdtime
> 1.25 and average waittime 1.48. So combined average holdtime
> spent while holding host and port locks decreased from 2.45 to
> 0.29 + 1.25 = 1.54 (about 1.6 times).
> 
> The downside of this change is introduction of a kernel thread.
> 
> The upside is shorter access time to port locks and moving port
> interrupts handling out of the hardware interrupt context.

IMHO it would be great to put the above results into the patch
description (it now looks a bit skimpy).

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

