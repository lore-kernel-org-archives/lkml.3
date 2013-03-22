Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161083Ab3CVRHu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 13:07:50 -0400
Received: from exprod7og109.obsmtp.com ([64.18.2.171]:47717 "EHLO
	exprod7og109.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161000Ab3CVRHs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 13:07:48 -0400
X-Forefront-Antispam-Report: CIP:157.56.241.149;KIP:(null);UIP:(null);(null);H:BL2PRD0511HT001.namprd05.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -3
X-BigFish: PS-3(zzbb2dI98dI1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275ch8275bhz2dh2a8h668h839h946he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1155h)
From: Benoit Lourdelet <blourdel@juniper.net>
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Serge Hallyn <serge.hallyn@ubuntu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        lxc-users <lxc-users@lists.sourceforge.net>
Subject: Re: [Lxc-users] Containers slow to start after 1600
Thread-Topic: [Lxc-users] Containers slow to start after 1600
Thread-Index: AQHOHnHbka0gSHH4mk6h9e1etrhar5igwnOAgAGPI4CAADkXgIAJTLEA///3UICAATVPAIAAXjqAgAAZTACAAAngAIAAQaHBgAFaDQD///fPSoAC+YUA
Date: Fri, 22 Mar 2013 17:05:44 +0000
Message-ID: <CD724CB7.72DE%blourdel@juniper.net>
In-Reply-To: <87vc8ldcy7.fsf@xmission.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/14.2.2.120421
x-originating-ip: [10.255.131.4]
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <02DF07C12D178E4DAFFABC13EC9B5598@namprd05.prod.outlook.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%12219$Dn%XMISSION.COM$RO%2$TLS%5$FQDN%onpremiseedge-1018244.customer.frontbridge.com$TlsDn%o365mail.juniper.net
X-FOPE-CONNECTOR: Id%12219$Dn%UBUNTU.COM$RO%2$TLS%5$FQDN%onpremiseedge-1018244.customer.frontbridge.com$TlsDn%o365mail.juniper.net
X-FOPE-CONNECTOR: Id%12219$Dn%VGER.KERNEL.ORG$RO%2$TLS%5$FQDN%onpremiseedge-1018244.customer.frontbridge.com$TlsDn%o365mail.juniper.net
X-FOPE-CONNECTOR: Id%12219$Dn%LISTS.SOURCEFORGE.NET$RO%2$TLS%5$FQDN%onpremiseedge-1018244.customer.frontbridge.com$TlsDn%o365mail.juniper.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I tried multiple kernels with similar results.

I ran the following on 3.8.2

$ cat > test-script.sh << 'EOF'
#!/bin/bash
for i in $(seq 1 2000) ; do
	ip link add a$i type veth peer name b$i
done
EOF

$ perf record -a test-script.sh
$ perf report


# event : name = cycles, type = 0, config = 0x0, config1 = 0x0, config2 =
0x0, excl_usr = 0, excl_kern = 0, excl_host = 0, excl_guest = 1,
precise_ip = 0, id = { 33
# HEADER_NUMA_TOPOLOGY info available, use -I to display
# pmu mappings: cpu = 4, software = 1, uncore_pcu = 15, tracepoint = 2,
uncore_imc_0 = 17, uncore_imc_1 = 18, uncore_imc_2 = 19, uncore_imc_3 =
20, uncore_qpi_0 = 2
# ========
#
# Samples: 2M of event 'cycles'
# Event count (approx.): 638240250735
#
# Overhead Command Shared Object Symbol
# ........ ............... .............................
.......................................ŠŠ.
#
    11.13% ip [kernel.kallsyms] [k] snmp_fold_field
   
     4.24% ip [kernel.kallsyms] [k] find_next_bit
   
     2.51% swapper [kernel.kallsyms] [k] intel_idle
        
     1.71% init libnih.so.1.0.0 [.] nih_list_add_after
   
     1.35% ip [kernel.kallsyms] [k] memcpy
   
     1.28% ip [xt_conntrack] [k] 0x0000000000005296
     1.26% ip [kernel.kallsyms] [k] rtnl_fill_ifinfo
   
     1.25% sed ld-2.15.so [.] 0x0000000000015972
     1.13% ifquery ld-2.15.so [.] 0x0000000000008bdb
 
     1.10% init [kernel.kallsyms] [k] page_fault
     
     1.00% ifquery [kernel.kallsyms] [k] page_fault
        
     0.97% init libc-2.15.so [.] 0x0000000000131e42
     0.94% sed [kernel.kallsyms] [k] page_fault
    
     0.75% ip [kernel.kallsyms] [k] inet6_fill_ifla6_attrs
   
     0.67% ip [kernel.kallsyms] [k] memset
   
     0.66% init [kernel.kallsyms] [k] copy_pte_range
     
     0.64% init init [.] 0x0000000000012433
     0.58% sed libc-2.15.so [.] 0x000000000008149a
     0.48% init libnih.so.1.0.0 [.] nih_tree_next_post_full




If I increase the number of links created , time spent for SNMP can even
increase :

12.04% ip [kernel.kallsyms] [k] snmp_fold_field
    
    12.03% sudo [kernel.kallsyms] [k] snmp_fold_field
          
     8.56% sudo libc-2.15.so [.] 0x000000000009198b
     
     4.39% sudo [kernel.kallsyms] [k] find_next_bit
          
     4.36% ip [kernel.kallsyms] [k] find_next_bit
        
     3.17% irqbalance libc-2.15.so [.] 0x000000000003d298
           
     2.01% init libnih.so.1.0.0 [.] nih_list_add_after
        
     1.63% ip [kernel.kallsyms] [k] rtnl_fill_ifinfo


Regards

Benoit


On 20/03/2013 21:38, "Eric W. Biederman" <ebiederm@xmission.com> wrote:

>Benoit Lourdelet <blourdel@juniper.net> writes:
>
>> Hello,
>>
>> The measurement has been done with kernel 3.8.2.
>>
>> Linux ieng-serv06 3.7.9 #3 SMP Wed Feb 27 02:38:58 PST 2013 x86_64
>>x86_64
>> x86_64 GNU/Linux
>
>Two different kernel versions?
>
>> What information would you like to see on the kernel ?
>
>The question is where is the kernel spending it's time.  So profiling
>information should help us see that.  Something like.
>
>$ cat > test-script.sh << 'EOF'
>#!/bin/bash
>for i in $(seq 1 2000) ; do
>	ip link add a$i type veth peer name b$i
>done
>EOF
>
>$ perf record -a -g test-script.sh
>$ perf report 
>
>I don't do anywhere enough work with perf to remember what good options
>are.
>
>You definititely don't want to time anything you are doing something
>silly like asking ip link add to generate device names which is O(N^2)
>when you create one device at a time.
>
>And of course there is the interesting discrepency.  Why can I add 5000
>veth pairs in 120 seconds and it takes you 1123 seconds.  Do you have a
>very
>slow cpu in your test environment?  Or was your test asking the kernel
>to generate names.
>
>Once we know where the kernel is spending it's time we can look to see
>if there is anything that is easy to fix, and where to point you.
>
>Both my timing and yours indicates that there is something taking O(N^2)
>time in there.  So it would at least be interesting to see what that
>something is.
>
>Eric
>


