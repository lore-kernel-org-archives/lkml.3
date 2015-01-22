Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297AbbAVApy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 19:45:54 -0500
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:56317 "HELO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754234AbbAVApu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 19:45:50 -0500
MIME-Version: 1.0
In-Reply-To: <CALnjE+rWu7HsmjK9O0KEzkgngh7fc62aMp-ecMrAZP_3r8gtSw@mail.gmail.com>
References: <1421778772-11879-1-git-send-email-joestringer@nicira.com>
 <1421778772-11879-6-git-send-email-joestringer@nicira.com>
 <CALnjE+qHjf5djBybPQUzoR_+dxDskQJQwtgvSN=G5NW9pckETw@mail.gmail.com>
 <CANr6G5yc1PZTAXHGrDJ-zLZf13UB4aef1hsQyK7RTPHzJMGoRg@mail.gmail.com> <CALnjE+rWu7HsmjK9O0KEzkgngh7fc62aMp-ecMrAZP_3r8gtSw@mail.gmail.com>
From: Joe Stringer <joestringer@nicira.com>
Date: Wed, 21 Jan 2015 16:45:24 -0800
Message-ID: <CANr6G5xSMeB0j12Ok98=1_iWUf-fFJmTDM-gsskd81JQ0SOp2g@mail.gmail.com>
Subject: Re: [PATCH net-next v13 5/5] openvswitch: Add support for unique flow IDs.
To: Pravin Shelar <pshelar@nicira.com>
Cc: netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "dev@openvswitch.org" <dev@openvswitch.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 January 2015 at 15:41, Pravin Shelar <pshelar@nicira.com> wrote:
> On Wed, Jan 21, 2015 at 11:29 AM, Joe Stringer <joestringer@nicira.com> wrote:
>> On 21 January 2015 at 10:31, Pravin Shelar <pshelar@nicira.com> wrote:
>>> On Tue, Jan 20, 2015 at 10:32 AM, Joe Stringer <joestringer@nicira.com> wrote:
>>>> Previously, flows were manipulated by userspace specifying a full,
>>>> unmasked flow key. This adds significant burden onto flow
>>>> serialization/deserialization, particularly when dumping flows.
>>>>
>>>> This patch adds an alternative way to refer to flows using a
>>>> variable-length "unique flow identifier" (UFID). At flow setup time,
>>>> userspace may specify a UFID for a flow, which is stored with the flow
>>>> and inserted into a separate table for lookup, in addition to the
>>>> standard flow table. Flows created using a UFID must be fetched or
>>>> deleted using the UFID.
>>>>
>>>> All flow dump operations may now be made more terse with OVS_UFID_F_*
>>>> flags. For example, the OVS_UFID_F_OMIT_KEY flag allows responses to
>>>> omit the flow key from a datapath operation if the flow has a
>>>> corresponding UFID. This significantly reduces the time spent assembling
>>>> and transacting netlink messages. With all OVS_UFID_F_OMIT_* flags
>>>> enabled, the datapath only returns the UFID and statistics for each flow
>>>> during flow dump, increasing ovs-vswitchd revalidator performance by 40%
>>>> or more.
>>>>
>>>> Signed-off-by: Joe Stringer <joestringer@nicira.com>
>>>
>>> Its almost ready. But I saw minor issues,
>>> few checkpatch.pl failures.
>>> in ovs_flow_cmd_new() we should use unmasked key to lookup in flow
>>> table for legacy case.
>>
>> Thanks for review, I can send out a fresh version soon. Should I
>> resend the whole series or is just a new version of this patch
>> sufficient?
>
> I think you have to send entire series. Dave will not apply series
> patches from different versions.

Thanks. I also realized there were checkpatch issues in the first
patch, so I resent the whole series anyway.
