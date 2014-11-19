Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933202AbaKSVxE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 16:53:04 -0500
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:37476 "HELO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757748AbaKSVw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 16:52:59 -0500
From: Joe Stringer <joestringer@nicira.com>
To: netdev@vger.kernel.org
Subject: Re: [PATCHv2 net] openvswitch: Fix mask generation for IPv6 labels.
Date: Wed, 19 Nov 2014 13:52:31 -0800
User-Agent: KMail/1.13.7 (Linux/3.2.0-4-amd64; KDE/4.8.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, pshelar@nicira.com, dev@openvswitch.org
References: <1416432001-35678-1-git-send-email-joestringer@nicira.com>
In-Reply-To: <1416432001-35678-1-git-send-email-joestringer@nicira.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201411191352.31914.joestringer@nicira.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 19, 2014 13:20:01 Joe Stringer wrote:
> When userspace doesn't provide a mask, OVS datapath generates a fully
> unwildcarded mask for the flow. This is done by taking a copy of the
> flow key, then iterating across its attributes, setting all values to
> 0xff. This works for most attributes, as the length of the netlink
> attribute typically matches the length of the value. However, IPv6
> labels only use the lower 20 bits of the field. This patch makes a
> special case to handle this.
> 
> This fixes the following error seen when installing IPv6 flows without a
> mask:
> 
> openvswitch: netlink: Invalid IPv6 flow label value (value=ffffffff,
> max=fffff)

Based on offlist discussion with Pravin, I'll send a patch for an alternative 
approach.
