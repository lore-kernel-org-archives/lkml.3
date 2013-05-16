Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229Ab3EPEjP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 00:39:15 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:63917 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058Ab3EPEjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 00:39:12 -0400
MIME-Version: 1.0
In-Reply-To: <CAJZOPZLjdALP4jkLo6p787jaPx=dkKj7+AmCr9+mgJN3z_xBxQ@mail.gmail.com>
References: <1368498506-25857-1-git-send-email-yinghai@kernel.org>
	<1368498506-25857-7-git-send-email-yinghai@kernel.org>
	<0EE9A1CDC8D6434DB00095CD7DB873462CFB0E4E@MTLDAG01.mtl.com>
	<CAE9FiQVn4F+dTrQn0xsg-6QY9+HwbnJR=1CrjdoZkmF_LMrgpg@mail.gmail.com>
	<CAJZOPZLjdALP4jkLo6p787jaPx=dkKj7+AmCr9+mgJN3z_xBxQ@mail.gmail.com>
Date: Wed, 15 May 2013 21:39:11 -0700
X-Google-Sender-Auth: SsVLg-L3Axt6K8DKgB604Jj6rqU
Message-ID: <CAE9FiQWvYQRCZjDx-Kh16nKfjfS=pyu8foJR+wWYS-x8DUZteg@mail.gmail.com>
Subject: Re: [PATCH 6/7] PCI: Make sure VF's driver get attached after PF's
From: Yinghai Lu <yinghai@kernel.org>
To: Or Gerlitz <or.gerlitz@gmail.com>
Cc: Yan Burman <yanb@mellanox.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jack Morgenstein <jackm@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yevgeny Petrilin <yevgenyp@mellanox.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 9:00 PM, Or Gerlitz <or.gerlitz@gmail.com> wrote:
> On Tue, May 14, 2013 at 11:43 AM, Yinghai Lu <yinghai@kernel.org> wrote:
>
>> BTW, do you have any plan to make mlx4 support sriov_configure via sysfs?
>
> yes we do, we're waiting for a firmware change that will allow for
> such a patch to get working.
>
> Please note that this whole lockdep warning was identified as false
> positive by Tejun http://www.spinics.net/lists/linux-pci/msg21568.html

No, at least one time, I noticed there is one real hang happens.
