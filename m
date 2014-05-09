Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819AbaEII0m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 04:26:42 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:59175 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298AbaEII0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 04:26:39 -0400
MIME-Version: 1.0
In-Reply-To: <20140509080706.GK26890@mwanda>
References: <20140509013948.GA30935@devel.8.8.4.4>
	<20140509080706.GK26890@mwanda>
Date: Fri, 9 May 2014 17:26:38 +0900
Message-ID: <CAHb8M2BM6H8Rutm9GEwaXv00QSTHOVtBJsvjEn-sLR9eYvRK=Q@mail.gmail.com>
Subject: Re: [PATCH 2/3] Staging: cxt1e1: Fix line length over 80 characters
 in musycc.c
From: DaeSeok Youn <daeseok.youn@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, devel <devel@driverdev.osuosl.org>,
        nandini h <nandu.hgowda@gmail.com>,
        "sachin.kamat" <sachin.kamat@linaro.org>,
        peter.p.waskiewicz.jr@intel.com,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Himangi Saraogi <himangi774@gmail.com>,
        Chekameh Cobbler <fempsci@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-05-09 17:07 GMT+09:00 Dan Carpenter <dan.carpenter@oracle.com>:
> This patch is ok, but here are some additional hints.
>
> On Fri, May 09, 2014 at 10:39:48AM +0900, Daeseok Youn wrote:
>> @@ -1100,7 +1102,9 @@ musycc_bh_rx_eom(mpi_t *pi, int gchan)
>>                        */
>>                       if (hdlcnum >= 228) {
>>                               if (nciProcess_RX_packet)
>> -                                     (*nciProcess_RX_packet) (hdlcnum, status & 0x3fff, m, ch->user);
>> +                                     (*nciProcess_RX_packet)(hdlcnum, status &
>> +                                                             0x3fff, m,
>> +                                                             ch->user);
>
> It's possible to break this one up at the commas.
Oh.. I will do that.
>
>                                         (*nciProcess_RX_packet)(hdlcnum,
>                                                                 status & 0x3fff,
>                                                                 m, ch->user);
>
>>                       } else
>>  #endif /* CONFIG_SBE_WAN256T3_NCOMM */
>>                       {
>> @@ -1379,7 +1383,8 @@ musycc_intr_bh_tasklet(ci_t *ci)
>>                       else
>>                               ci->iqd_p[headx] =
>>                                       __constant_cpu_to_le32(INT_EMPTY_ENTRY);
>> -                     ci->iqp_headx = (headx + 1) & (INT_QUEUE_SIZE - 1); /* insure wrapness */
>> +                     /* insure wrapness */
>> +                     ci->iqp_headx = (headx + 1) & (INT_QUEUE_SIZE - 1);
>>                       FLUSH_MEM_WRITE();
>>                       FLUSH_MEM_READ();
>>                       continue;
>> @@ -1516,7 +1521,8 @@ musycc_intr_bh_tasklet(ci_t *ci)
>>                                       pr_info("%s: RX buffer overflow [ONR] on channel %d, mode %x\n",
>>                                               ci->devname, ch->channum,
>>                                               ch->p.chan_mode);
>> -                                     //musycc_dump_rxbuffer_ring (ch, 0);        /* RLD DEBUG */
>> +                                     /* RLD DEBUG */
>> +                                     //musycc_dump_rxbuffer_ring (ch, 0);
>
> Just delete this commented out code.
Yes. it can be removed.
>
>>                               }
>>                       }
>>                       musycc_chan_restart(ch);
>> @@ -1573,7 +1579,8 @@ musycc_intr_bh_tasklet(ci_t *ci)
>>               } /* switch on err */
>>
>>               /* Check for interrupt lost condition */
>> -             if ((currInt & INTRPT_ILOST_M) && (cxt1e1_log_level >= LOG_ERROR))
>> +             if ((currInt & INTRPT_ILOST_M) &&
>> +                 (cxt1e1_log_level >= LOG_ERROR))
>>                       pr_info("%s: Interrupt queue overflow - ILOST asserted\n",
>>                               ci->devname);
>>               /* insure wrapness */
>> @@ -1684,7 +1691,8 @@ musycc_del_chan(ci_t *ci, int channum)
>>  {
>>       mch_t      *ch;
>>
>> -     if ((channum < 0) || (channum >= (MUSYCC_NPORTS * MUSYCC_NCHANS)))  /* sanity chk param */
>> +     /* sanity chk param */
>
> This kind of comment is too obvious.  Just delete it.
musycc_del_chan() in "#if 0" block will be removed it is not needed.
>
>> +     if ((channum < 0) || (channum >= (MUSYCC_NPORTS * MUSYCC_NCHANS)))
>>               return ECHRNG;
>>       ch = sd_find_chan(ci, channum);
>>       if (!ch)
>
> regards,
> dan carpenter

Thanks.

Regards,
Daeseok Youn.
