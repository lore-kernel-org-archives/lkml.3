Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934280AbaGPFkT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 01:40:19 -0400
Received: from 99-65-72-228.uvs.sntcca.sbcglobal.net ([99.65.72.228]:11109
	"EHLO stargate.chelsio.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934241AbaGPFkR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 01:40:17 -0400
From: Anish Bhatt <anish@chelsio.com>
To: Joe Perches <joe@perches.com>, Ethan Zhao <ethan.zhao@oracle.com>
CC: "apw@canonical.com" <apw@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ethan.kernel@gmail.com" <ethan.kernel@gmail.com>,
        "joe.jin@oracle.com" <joe.jin@oracle.com>
Subject: RE: [Bug report] Hit false positives bug with script/checkpatch.pl
Thread-Topic: [Bug report] Hit false positives bug with script/checkpatch.pl
Thread-Index: AQHPoK1MeswyH/bCSE+CrbqZhqlo35uiK4zT
Date: Wed, 16 Jul 2014 05:39:06 +0000
Message-ID: <525DB349B3FB5444AE057A887CB2A8D8543381@nice.asicdesigners.com>
References: <1405479036-6763-1-git-send-email-ethan.zhao@oracle.com>,<1405484432.14773.19.camel@joe-AO725>
In-Reply-To: <1405484432.14773.19.camel@joe-AO725>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.163.158]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Parantheses/do {...} while(0) would not work for direct value substituons like this obviously but fixing this false positive seems hard. An exception case that is something like "macros with complex values separated by commas but no statements terminated by semicolons" is my best but seems-very-vague guess.
-Anish
________________________________________
From: Joe Perches [joe@perches.com]
Sent: Tuesday, July 15, 2014 9:20 PM
To: Ethan Zhao
Cc: Anish Bhatt; apw@canonical.com; linux-kernel@vger.kernel.org; ethan.kernel@gmail.com; joe.jin@oracle.com
Subject: Re: [Bug report] Hit false positives bug with script/checkpatch.pl

On Wed, 2014-07-16 at 10:50 +0800, Ethan Zhao wrote:
> Hi,
>      I hit a false positives bug when run script/checkpatch.pl to my patch,
> It reported  errors to following macro definition, but in fact the macro is
> correct, I couldn't change that macro according to the error message output
> by script/checkpatch.pl. because of this bug, my patch was rejected by some
> guy's patchwork.

You could tell the guy checkpatch isn't always right.

You could also change the macro to something like:

#define NETXEN_NIC_STAT(name, m)                                \
{                                                               \
        .name = name,                                           \
        .type = m,                                              \
        .sizeof_stat = FIELD_SIZEOF(struct netxen_adapter, m),  \
        .stat_offset = offsetof(struct netxen_adapter, m)       \
}

and change the uses like:

static const struct netxen_nic_stats netxen_nic_gstrings_stats[] = {
        NETXEN_NIC_STAT("xmit called", stats.xmitcalled),
        NETXEN_NIC_STAT("xmit_finished", stats.xmitfinished),

etc...


