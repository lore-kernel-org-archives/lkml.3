Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751707AbaC2MWW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 08:22:22 -0400
Received: from mail-ie0-f196.google.com ([209.85.223.196]:32871 "EHLO
	mail-ie0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbaC2MWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 08:22:21 -0400
MIME-Version: 1.0
Date: Sat, 29 Mar 2014 13:22:21 +0100
Message-ID: <CAOte+=YgX=0dahqCS6-=yBLHnTjoJtii3Ycx4mhrj9SqNADZzg@mail.gmail.com>
Subject: Support for netconsole as default tty/console?
From: Struan Bartlett <struan.bartlett@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I help maintain a range of raw metal hosts, VMs, and Amazon EC2
instances that boot Linux within secure private networks. Where
possible, we connect raw metal hosts to a central logging server using
serial lines, and use the console=ttyS0 kernel command line option to
redirect not just kernel boot logs, but all boot script tty output,
via the serial line for central logging. This is particularly useful,
as when critical start-up scripts report issues to the console (as
opposed to logs files) those issues can be monitored centrally, and
diagnosed without the need to log in. In some cases, critical error
messages are only logged to the console, and not to the logs files.

Serial lines do not scale well and, on some of our VMs, and certainly
on EC2 instances, platforms are headless and may be accessed only by
our private network. As mentioned, our systems are running in known
secure private networks accessible only to sysadmins, so
authenticating access to the terminal output is not a particular
concern.

We have had a good experience of using netconsole to provide remote
real-time access to the kernel logs during Linux boot, via our syslog
server. However we have yet to find a reliable way to redirect all
console output (i.e. start-up script not just kernel logs) via the
private network to our logging server, as is possible via a serial
line. We have tried to address the issue in user-space. Patching of
boot scripts to pipe output via tee and socat has been attempted, but
it is hard to make this work comprehensively, and it appears to
interfere with standard shutdown scripts that expect all processes to
be able to be killed (without terminating standard output/error pipes)
before switching run levels.

Adding console=netconsole to the command line does not appear to have
the desired effect. I am not sure if this is because netconsole,
unlike the serial console, does not provide a tty. Can anyone advise
if this understanding is correct? If so, is there an independent
solution to this problem? Failing that, is there general interest in a
tty-capable (maybe output only) extension to the netconsole module?

Kind regards
