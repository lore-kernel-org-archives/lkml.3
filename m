Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756957AbaGWLdV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 07:33:21 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:50095 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886AbaGWLdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 07:33:19 -0400
Date: Wed, 23 Jul 2014 12:33:14 +0100
From: Stephane Chazelas <stephane.chazelas@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: network interfaces called "all", "default" or "config"
Message-ID: <20140723113314.GA7798@chaz.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hiya,

you may want to forbid the creation of interfaces whose name is
one of the special files in /proc/net and /proc/sys.

I can see some characters (like space, tab, newline, slash,
dot...) are alread forbidden in interface names (EINVAL), but
one can do for instance:

sudo ip link add link eth0 all type vlan id 2
sudo ip link add link eth0 default type vlan id 3
sudo ip link add link eth0 config type vlan id 4

Interestingly, after you add a "all" or "default", the
corresponding /proc/sys/net/ipv[46]/conf/(all|default) become
empty, and remain so even after you've removed the interface.

Adding an interface called "config" masks /proc/net/vlan/config

(tested with 3.14-1-amd64 on debian)

-- 
Stephane
