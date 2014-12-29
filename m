Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296AbaL2USz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 15:18:55 -0500
Received: from mout.gmx.net ([212.227.15.19]:49237 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751505AbaL2USy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 15:18:54 -0500
Message-ID: <54A1B724.8070106@gmx.de>
Date: Mon, 29 Dec 2014 21:18:44 +0100
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Paul Moore <paul@paul-moore.com>
CC: linux Kernel <linux-kernel@vger.kernel.org>, linux-audit@redhat.com
Subject: Re: v3.19-rc2: crashes during boot (syslog-ng, rpcbind ...)
References: <54A17C49.5080102@gmx.de> <CAHC9VhTT1WqGfuOLpXw1o2ZE5Bhwg35KCc1Gg2-bYtFX9jAYRg@mail.gmail.com> <54A18046.9060209@gmx.de> <4182091.odzUCAWhED@sifl>
In-Reply-To: <4182091.odzUCAWhED@sifl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:GAT9tbMhCMIzUo6qHdM/k9IjuMdFq3wiUnj2IfG9Q7gerxWWhl3
 Uw11UXmqZGRTNReo/CYZXhdgdAJNpkSyYjfTGBRgCqM3tbZ4LB/7JDVGeaXjPOM4bbPCXaw
 C26bVmEl+zldB1Aq3x4lqOxgtYzrLcAwbZkpRQ0WbHUSrIPmLYFmZQ1Lw/csERmoXBXj71c
 x9KQmTBF6CJC7VprpLt4g==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/29/2014 08:41 PM, Paul Moore wrote:
> To help verify that I'm heading down the right path, could you share your 
> audit configuration as well?  If that's not possible, can you at least confirm 
> that you using a few audit directory watches?

Well, it is just a victim system for trinity - but I did not configured auditd in a special manner - so it is just the plain default configuration of Gentoo:

n22kvm-clone audit # wc *
  26  201 1127 audit.rules
  13   85  573 audit.rules.stop.post
  16   81  547 audit.rules.stop.pre
  32   95  701 auditd.conf
  87  462 2948 total
n22kvm-clone audit # tail -n 40 -v *
==> audit.rules <==                                                                                                
# Copyright 1999-2011 Gentoo Foundation                                                                            
# Distributed under the terms of the GNU General Public License v2                                                 
# $Header: /var/cvsroot/gentoo-x86/sys-process/audit/files/audit.rules-2.1.3,v 1.1 2011/09/11 02:58:55 robbat2 Exp $
#                                                                                                                  
# This file contains the auditctl rules that are loaded                                                            
# whenever the audit daemon is started via the initscripts.                                                        
# The rules are simply the parameters that would be passed                                                         
# to auditctl.                                                                                                     
                                                                                                                                  
# First rule - delete all                                                                                                         
# This is to clear out old rules, so we don't append to them.                                                                     
-D                                                                                                                                
                                                                                                                                                    
# Feel free to add below this line. See auditctl man page                                                                                           
                                                                                                                                                    
# The following rule would cause all of the syscalls listed to be ignored in logging.                                                               
-a exit,never -F arch=b32 -S read -S write -S open -S fstat -S mmap -S brk -S munmap -S nanosleep -S fcntl -S close -S dup2 -S rt_sigaction -S stat                          
#-a exit,never -F arch=b64 -S read -S write -S open -S fstat -S mmap -S brk -S munmap -S nanosleep -S fcntl -S close -S dup2 -S rt_sigaction -S stat                         
                                                                                                                                                                             
# The following rule would cause the capture of all systems not caught above.                                                                                                
# -a exit,always -S all                                                                                                                                                      
                                                                                                                                                                             
# Increase the buffers to survive stress events                                                                                                                              
-b 8192                                                                                                                                                                      
                                                                                                                                                                             
# vim:ft=conf:                                                                                                                                                               
                                                                                                                                                                             
==> audit.rules.stop.post <==                                                                                                                                                
# Copyright 1999-2005 Gentoo Foundation                                                                                                                                      
# Distributed under the terms of the GNU General Public License v2                                                                                                           
# $Header: /var/cvsroot/gentoo-x86/sys-process/audit/files/audit.rules.stop.post,v 1.1 2006/06/22 07:41:46 robbat2 Exp $                                                     
#                                                                                                                                                                            
# This file contains the auditctl rules that are loaded immediately after the                                                                                                
# audit deamon is stopped via the initscripts.                                                                                                                               
# The rules are simply the parameters that would be passed
# to auditctl.

# Not used for the default Gentoo configuration as of v1.2.3
# Paranoid security types might wish to reconfigure kauditd here.

# vim:ft=conf:

==> audit.rules.stop.pre <==
# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-process/audit/files/audit.rules.stop.pre,v 1.2 2011/09/11 02:58:55 robbat2 Exp $
#
# This file contains the auditctl rules that are loaded immediately before the
# audit deamon is stopped via the initscripts.
# The rules are simply the parameters that would be passed
# to auditctl.

# auditd is stopping, don't capture events anymore
-D

# Disable kernel generating audit events
-e 0

# vim:ft=conf:

==> auditd.conf <==
#
# This file controls the configuration of the audit daemon
#

log_file = /var/log/audit/audit.log
log_format = RAW
log_group = root
priority_boost = 4
flush = INCREMENTAL
freq = 20
num_logs = 5
disp_qos = lossy
dispatcher = /sbin/audispd
name_format = NONE
##name = mydomain
max_log_file = 6 
max_log_file_action = ROTATE
space_left = 75
space_left_action = SYSLOG
action_mail_acct = root
admin_space_left = 50
admin_space_left_action = SUSPEND
disk_full_action = SUSPEND
disk_error_action = SUSPEND
##tcp_listen_port = 
tcp_listen_queue = 5
tcp_max_per_addr = 1
##tcp_client_ports = 1024-65535
tcp_client_max_idle = 0
enable_krb5 = no
krb5_principal = auditd
##krb5_key_file = /etc/audit/audit.key



n22kvm-clone audit # cat /etc/conf.d/auditd 
# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-process/audit/files/auditd-conf.d-2.1.3,v 1.1 2011/09/11 02:58:55 robbat2 Exp $

# Configuration options for auditd
# -f for foreground mode
# There are some other options as well, but you'll have to look in the source
# code to find them as they aren't ready for use yet.
EXTRAOPTIONS=''

# Audit rules file to run after starting auditd
RULEFILE_STARTUP=/etc/audit/audit.rules

# Audit rules file to run before and after stopping auditd
RULEFILE_STOP_PRE=/etc/audit/audit.rules.stop.pre
RULEFILE_STOP_POST=/etc/audit/audit.rules.stop.post

# If you want to enforce a certain locale for auditd, 
# uncomment one of the next lines:
#AUDITD_LANG=none
AUDITD_LANG=C
#AUDITD_LANG=en_US
#AUDITD_LANG=en_US.UTF-8



-- 
Toralf
pgp key: 7B1A 07F4 EC82 0F90 D4C2  8936 872A E508 0076 E94E

