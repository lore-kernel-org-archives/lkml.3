Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751405AbaAERIh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 12:08:37 -0500
Received: from mout3.freenet.de ([195.4.92.93]:58452 "EHLO mout3.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751243AbaAERIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 12:08:36 -0500
Date: Sun, 5 Jan 2014 18:06:12 +0100
From: Andreas Hartmann <andihartmann@01019freenet.de>
To: linux-kernel@vger.kernel.org
Subject: Re: Strange problem with vxlan!
Message-ID: <20140105180612.1234613e@dualc.maya.org>
In-Reply-To: <20140103152719.4a8db2ce@dualc.maya.org>
References: <20140103152719.4a8db2ce@dualc.maya.org>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Originated-At: 79.222.10.153!33205
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Jan 2014 15:27:19 +0100
Andreas Hartmann <andihartmann@01019freenet.de> wrote:

[...]

> Now the problem:
> 
> If the VM (=AP) runs e.g. Linux 3.4.x, all is working fine as expected. 
> If the VM runs 3.12.x or even 3.10.x, the tunnel works fine a few minutes after creation. Afterwards it is broken.
> 
> Broken means:
> A "dhcpcd eth0" e.g. on the notebook times out, doesn't work any more. Traces show:
> The udp-tunnel-packages sent by the STA through vxlan0 can be seen on the host / tap0, but they can't be seen on vxlan0 (if it works, they can be seen on the vxlan0 device, too).
> 
> On the host runs Linux 3.10.x, on the STA 3.11.6.

Some more findings:

- Problem can be seen with Linux 3.7 in the AP (VM), too.
- *Problem disappears* if the bridge device br0 on the host is set to
  promiscuous mode.
- Sometimes, there can be seen the warning 
  "notebook dhcpcd[2784]: eth0: bad UDP checksum, ignoring" 
  when starting dhcpcd on the notebook with br0 / host set to promiscuous
  mode (nevertheless dhcpcd worked fine). I never saw this warning
  before.


Any idea how to fix the problem w/o running the bridge br0 on the host
in promiscuous mode?



Thanks for any hint,
Andreas
