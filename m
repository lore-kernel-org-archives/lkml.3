Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515AbaLXPm1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 10:42:27 -0500
Received: from mail.kmu-office.ch ([178.209.48.109]:35751 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbaLXPmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 10:42:25 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Date: Wed, 24 Dec 2014 16:42:04 +0100
From: Stefan Agner <stefan@agner.ch>
To: Peter Chen <peter.chen@freescale.com>
Cc: Sanchayan Maity <maitysanchayan@gmail.com>, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] usb: chipidea: add one errata for revision 2.40a
In-Reply-To: <20141222011840.GB9242@shlinux2>
References: <cover.1418981438.git.maitysanchayan@gmail.com>
 <20141222011840.GB9242@shlinux2>
Message-ID: <5f3945e8a47cc7c2e74a758671df4dea@agner.ch>
User-Agent: Roundcube Webmail/1.0.3
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed Dec 24 16:41:14 2014
X-DSPAM-Confidence: 0.9899
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 549ade9a12812103916489
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-12-22 02:18, Peter Chen wrote:
> On Fri, Dec 19, 2014 at 03:25:26PM +0530, Sanchayan Maity wrote:
>> The first two patches add identification register API's. These can
>> be used to get controller's revision.
>>
>> The third patch implements an errata for revision 2.40a. Not sure
>> which other SOCs implement this version of the Chipidea core but
>> this fixes the usb client issue observed on Vybrids. The patch was
>> tested on a Toradex Colibri VF61 module with the 3.18 kernel. iperf
>> tests ran for three hours plus, with these patches applied have found
>> the USB client connection to be now reliable.
> 
> Would you help do a overnight test? It is passed, I will queue them,
> thanks.
> 

Hi Peter,

Also did a short test on 3.19-rc1 here:
# iperf -s
------------------------------------------------------------
Server listening on TCP port 5001
TCP window size: 85.3 KByte (default)
------------------------------------------------------------
[  4] local 192.168.1.10 port 5001 connected with 192.168.1.1 port 53241
[ ID] Interval       Transfer     Bandwidth
[  4]  0.0-10.0 sec   152 MBytes   127 Mbits/sec
[  5] local 192.168.1.10 port 5001 connected with 192.168.1.1 port 53243
[  8] local 192.168.1.10 port 5001 connected with 192.168.1.1 port 53247
[  7] local 192.168.1.10 port 5001 connected with 192.168.1.1 port 53246
[  6] local 192.168.1.10 port 5001 connected with 192.168.1.1 port 53245
[  4] local 192.168.1.10 port 5001 connected with 192.168.1.1 port 53244
[  6]  0.0-10.1 sec  30.9 MBytes  25.7 Mbits/sec
[  5]  0.0-10.1 sec  30.9 MBytes  25.7 Mbits/sec
[  7]  0.0-10.1 sec  30.9 MBytes  25.7 Mbits/sec
[  8]  0.0-10.1 sec  30.9 MBytes  25.6 Mbits/sec
[  4]  0.0-10.1 sec  30.9 MBytes  25.7 Mbits/sec
[SUM]  0.0-10.1 sec   154 MBytes   128 Mbits/sec

Tried also UDP mode and scp copies as well as adding some kernel level
latencies by pluging and unpluging a USB mass storage device. Looks good
to me as well:
Tested-by: Stefan Agner <stefan@agner.ch>

Btw, this was and solves now the error I was mentioning in my patchset
enabling Vybrid support:

http://lists.infradead.org/pipermail/linux-arm-kernel/2014-July/274342.html

@Sanchayan/Peter:
Minor nits as reply to the actual patch emails.

--
Stefan



> Peter
>>
>> This patchset is based off on Shawn Guo's for-next branch
>> https://git.kernel.org/cgit/linux/kernel/git/shawnguo/linux.git/tree/?h=for-next
>>
>> The credit for the patches and fix goes to Matthieu Castet and Peter Chen.
>> First two patches are by Peter Chen and the third patch which fixed the
>> bug we observed was reported by Matthieu Castet.
>>
>> The discussion of the problem and the relevant testing details can be found
>> at this link: http://www.spinics.net/lists/linux-usb/msg118544.html
>>
>> The first version of this patchset originally send by Peter Chen can be
>> found at this link: http://www.spinics.net/lists/linux-usb/msg118753.html
>>
>> Comments for review are welcome :).
>> Note: I am going on a vacation so will not be able to reply or do any further
>> tests till Monday. Will attend and take care of any comments/requests for
>> further changes/testing from Tuesday. Apologize for the delay in advance.
>>
>> Sanchayan Maity (3):
>>   usb: chipidea: Add identification registers access APIs
>>   usb: chipidea: Add chipidea revision information
>>   usb: chipidea: Add errata for revision 2.40a
>>
>>  drivers/usb/chipidea/bits.h |   10 ++++++++
>>  drivers/usb/chipidea/ci.h   |   53 +++++++++++++++++++++++++++++++++++++++++++
>>  drivers/usb/chipidea/core.c |   23 +++++++++++++++++--
>>  drivers/usb/chipidea/udc.c  |   20 ++++++++++++++++
>>  4 files changed, 104 insertions(+), 2 deletions(-)
>>
>> --
>> 1.7.9.5
>>

