Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702AbaIONHT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 09:07:19 -0400
Received: from plane.gmane.org ([80.91.229.3]:55260 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751036AbaIONHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 09:07:17 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Aleksei Besogonov <alex.besogonov@gmail.com>
Subject: Run a script with =?utf-8?b?Y2FwX25ldF9iaW5kX3NlcnZpY2U=?= - mission impossible.
Date: Mon, 15 Sep 2014 13:07:03 +0000 (UTC)
Message-ID: <loom.20140915T145605-849@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 50.184.243.33 (Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:32.0) Gecko/20100101 Firefox/32.0)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

It seems that it's totally impossible to start a script with
cap_net_bind_service capability and as a non-root user without modifying
system-wide settings.

I've trawled the Net for a solution that should be exceedingly simple. I
want to run a daemon under a non-privileged account AND allow it to bind to
'secure' ports (443, 589 and 53). So far I found the following non-solutions:

- Use iptables to redirect ports. Doesn't work with local traffic.
- Use an HTTP proxy server (yeah, and also a DNS proxy server).
- Set cap_net_bind_service capability bit on the script interpreter (so
it'll break during upgrades). 
- Fuck you, run it under the root user. With several permutations like:
  * Dropping caps after opening sockets (can't do this)
  * Dropping all caps before starting the interpreter (fucks up the file
ownership)

I've tried without any luck various permutations of capsh like: capsh
--keep=1 --secbits=5 --user=cyberax --caps=cap_net_bind_service+eip -- -c
'nc -l 443'

So is it possible at all?

