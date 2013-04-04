Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758891Ab3DDKW0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 06:22:26 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:59414 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758813Ab3DDKWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 06:22:23 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: dingtianhong <dingtianhong@huawei.com>
Cc: "David S. Miller" <davem@davemloft.net>, Sven Joachim <svenjoac@gmx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Andy Lutomirski <luto@amacapital.net>, Karel Srot <ksrot@redhat.com>,
        <netdev@vger.kernel.org>, Eric Dumazet <eric.dumazet@gmail.com>
References: <20130402221104.163133110@linuxfoundation.org>
	<20130402221116.307254752@linuxfoundation.org>
	<87vc833kpf.fsf@turtle.gmx.de> <87k3ojnosa.fsf@xmission.com>
	<1365034777.13853.46.camel@edumazet-glaptop>
	<1365035424.13853.48.camel@edumazet-glaptop>
	<878v4zjei0.fsf@xmission.com> <87li8zhwkw.fsf_-_@xmission.com>
	<515D30F6.9010004@huawei.com>
Date: Thu, 04 Apr 2013 03:22:07 -0700
In-Reply-To: <515D30F6.9010004@huawei.com> (dingtianhong@huawei.com's message
	of "Thu, 4 Apr 2013 15:51:18 +0800")
Message-ID: <87r4iqegts.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18JsM7Q9K8B/vGHUEhk6ZO02zIBfPPceoQ=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.7 KHOP_BIG_TO_CC Sent to 10+ recipients instaed of Bcc or a list
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;dingtianhong <dingtianhong@huawei.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 1/2] Revert "af_unix: dont send SCM_CREDENTIAL when dest socket is NULL"
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dingtianhong <dingtianhong@huawei.com> writes:

> On 2013/4/4 10:13, Eric W. Biederman wrote:
>> 
>> This reverts commit 14134f6584212d585b310ce95428014b653dfaf6.
>> 
>> The problem that the above patch was meant to address is that af_unix
>> messages are not being coallesced because we are sending unnecesarry
>> credentials.  Not sending credentials in maybe_add_creds totally
>> breaks unconnected unix domain sockets that wish to send credentails
>> to other sockets.
>> 
>
> thanks for check the question and make a fix solution, but I still doubt that if unconnected unix
> domain socket wish to send credentails to oher sockets, why dont set
> SOCK_PASSCRED on sock->flags, I think the user need to decide the param
> and shouldnt send creds by default way.

The big issue is the semantics are the receiver sets SOCK_PASSCRED when
they want to receive credentials.  When transmitting packets from
unconnected or unaccepted sockets we don't know if the receiver has set
SOCK_PASSCRED so when in doubt transmit. Historically we always
tranmitted credentials.

Furthermore we have a real regression in udev that breaks systems, so
this patch must be reverted.

Eric
