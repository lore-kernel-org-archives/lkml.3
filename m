Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759983Ab3CZS12 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 14:27:28 -0400
Received: from mail-bl2lp0211.outbound.protection.outlook.com ([207.46.163.211]:16164
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753356Ab3CZS11 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 14:27:27 -0400
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT003.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: 1
X-BigFish: PS1(zz9371I542I1432I1521Ic8kzz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz31h2a8h668h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h19ceh1ad9h1b0ah9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:SN2PR03MB061;H:SN2PR03MB061.namprd03.prod.outlook.com;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        Evgeniy Polyakov <zbr@ioremap.net>
Subject: RE: [PATCH V2 1/1] Drivers: hv: Add a new driver to support host
 initiated backup
Thread-Topic: [PATCH V2 1/1] Drivers: hv: Add a new driver to support host
 initiated backup
Thread-Index: AQHOIa9jd5OqsHAaYE6mIfFRqEann5i3veYAgAB+cFA=
Date: Tue, 26 Mar 2013 18:25:35 +0000
Message-ID: <87df2da43513408f96da2185be680cd3@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1363375806-19979-1-git-send-email-kys@microsoft.com>
 <51516422.8000804@redhat.com>
In-Reply-To: <51516422.8000804@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [98.110.61.163]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PR03MB061.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%IOREMAP.NET$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC107.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC107.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(54094002)(51704002)(13464002)(377454001)(199002)(189002)(56776001)(5343635001)(74662001)(47776003)(53806001)(63696002)(4396001)(23726001)(47736001)(46406002)(50986001)(65816001)(31966008)(6806001)(77982001)(59766001)(16676001)(80022001)(50466001)(76482001)(56816002)(66066001)(33646001)(54356001)(46102001)(54316002)(49866001)(69226001)(79102001)(47446002)(74502001)(51856001)(47976001)(20776003)(2004001)(24736002)(550254004);DIR:OUT;SFP:;SCL:1;SRVR:BN1BFFO11HUB005;H:TK5EX14HUBC107.redmond.corp.microsoft.com;RD:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 079756C6B9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Paolo Bonzini [mailto:paolo.bonzini@gmail.com] On Behalf Of Paolo
> Bonzini
> Sent: Tuesday, March 26, 2013 5:02 AM
> To: KY Srinivasan
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> jasowang@redhat.com; Evgeniy Polyakov
> Subject: Re: [PATCH V2 1/1] Drivers: hv: Add a new driver to support host
> initiated backup
> 
> > diff --git a/tools/hv/hv_vss_daemon.c b/tools/hv/hv_vss_daemon.c
> > new file mode 100644
> > index 0000000..9526995
> > --- /dev/null
> > +++ b/tools/hv/hv_vss_daemon.c
> > @@ -0,0 +1,220 @@
> > +/*
> > + * An implementation of the host initiated guest snapshot for Hyper-V.
> > + *
> > + *
> > + * Copyright (C) 2013, Microsoft, Inc.
> > + * Author : K. Y. Srinivasan <kys@microsoft.com>
> > + *
> > + * This program is free software; you can redistribute it and/or modify it
> > + * under the terms of the GNU General Public License version 2 as published
> > + * by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful, but
> > + * WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE
> or
> > + * NON INFRINGEMENT.  See the GNU General Public License for more
> > + * details.
> > + *
> > + */
> > +
> > +
> > +#include <sys/types.h>
> > +#include <sys/socket.h>
> > +#include <sys/poll.h>
> > +#include <linux/types.h>
> > +#include <stdio.h>
> > +#include <stdlib.h>
> > +#include <unistd.h>
> > +#include <string.h>
> > +#include <ctype.h>
> > +#include <errno.h>
> > +#include <arpa/inet.h>
> > +#include <linux/connector.h>
> > +#include <linux/hyperv.h>
> > +#include <linux/netlink.h>
> > +#include <syslog.h>
> > +
> > +static char vss_recv_buffer[4096];
> > +static char vss_send_buffer[4096];
> > +static struct sockaddr_nl addr;
> > +
> > +#ifndef SOL_NETLINK
> > +#define SOL_NETLINK 270
> > +#endif
> > +
> > +
> > +static int vss_operate(int operation)
> > +{
> > +	char *fs_op;
> > +	char cmd[512];
> > +	char buf[512];
> > +	FILE *file;
> > +	char *p;
> > +	char *x;
> > +	int error;
> > +
> > +	switch (operation) {
> > +	case VSS_OP_FREEZE:
> > +		fs_op = "-f ";
> > +		break;
> > +	case VSS_OP_THAW:
> > +		fs_op = "-u ";
> > +		break;
> > +	}
> > +
> > +	file = popen("mount | awk '/^\/dev\// { print $3}'", "r");
> > +	if (file == NULL)
> > +		return;
> > +
> > +	while ((p = fgets(buf, sizeof(buf), file)) != NULL) {
> > +		x = strchr(p, '\n');
> > +		*x = '\0';
> > +		if (!strncmp(p, "/", sizeof("/")))
> > +			continue;
> > +
> > +		sprintf(cmd, "%s %s %s", "fsfreeze ", fs_op, p);
> 
> Please use getmntent and FIFREEZE/FITHAW.

I think Olaf has already addressed this in the recent patches he has sent.

> 
> However, I wonder if a dedicated daemon is really the best mechanism.
> Perhaps you can use uevents instead, and trigger the freeze/thaw with
> udev rules?

I need to be able to return errors back from the freeze/thaw operations.

Regards,

K. Y

