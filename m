Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760173Ab3CZSsI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 14:48:08 -0400
Received: from mail-by2lp0238.outbound.protection.outlook.com ([207.46.163.238]:14735
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751628Ab3CZSsG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 14:48:06 -0400
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT002.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -1
X-BigFish: PS-1(zz9371I542I1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275dh8275bhz31h2a8h668h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h19ceh1ad9h1b0ah9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:SN2PR03MB062;H:SN2PR03MB061.namprd03.prod.outlook.com;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: Olaf Hering <olaf@aepfle.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/3] tools: hv: fix checks for origin of netlink message
 in hv_vss_daemon
Thread-Topic: [PATCH 2/3] tools: hv: fix checks for origin of netlink
 message in hv_vss_daemon
Thread-Index: AQHOKjbAdfuLw3Z1oUW5wWnZJgp7ypi4T5dQ
Date: Tue, 26 Mar 2013 18:45:02 +0000
Message-ID: <74a79d1d3e39402782d845191ff202ba@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1364311709-18228-1-git-send-email-olaf@aepfle.de>
 <1364311709-18228-2-git-send-email-olaf@aepfle.de>
In-Reply-To: <1364311709-18228-2-git-send-email-olaf@aepfle.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [98.110.61.163]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PR03MB062.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC104.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC104.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(51704002)(13464002)(377454001)(189002)(199002)(4396001)(47736001)(56816002)(31966008)(76482001)(23726001)(47976001)(65816001)(80022001)(5343655001)(54356001)(5343635001)(50986001)(44976002)(49866001)(46406002)(20776003)(47776003)(53806001)(47446002)(74662001)(59766001)(66066001)(63696002)(50466001)(6806001)(56776001)(54316002)(74502001)(69226001)(33646001)(51856001)(79102001)(16676001)(46102001)(77982001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BL2FFO11HUB010;H:TK5EX14HUBC104.redmond.corp.microsoft.com;RD:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 079756C6B9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Olaf Hering [mailto:olaf@aepfle.de]
> Sent: Tuesday, March 26, 2013 11:28 AM
> To: KY Srinivasan; gregkh@linuxfoundation.org
> Cc: linux-kernel@vger.kernel.org; Olaf Hering
> Subject: [PATCH 2/3] tools: hv: fix checks for origin of netlink message in
> hv_vss_daemon
> 
> Similar to what commit 95a69adab9acfc3981c504737a2b6578e4d846ef ("tools:
> hv: Netlink source address validation allows DoS") does in
> hv_kvp_daemon, improve checks for origin of netlink connector message.
> 
> Signed-off-by: Olaf Hering <olaf@aepfle.de>

Acked by: K. Y. Srinivasan <kys@microsoft.com>
> ---
>  tools/hv/hv_vss_daemon.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/hv/hv_vss_daemon.c b/tools/hv/hv_vss_daemon.c
> index 2a03d0b..dc3eb1e 100644
> --- a/tools/hv/hv_vss_daemon.c
> +++ b/tools/hv/hv_vss_daemon.c
> @@ -186,13 +186,19 @@ int main(void)
>  		len = recvfrom(fd, vss_recv_buffer, sizeof(vss_recv_buffer), 0,
>  				addr_p, &addr_l);
> 
> -		if (len < 0 || addr.nl_pid) {
> +		if (len < 0) {
>  			syslog(LOG_ERR, "recvfrom failed; pid:%u error:%d %s",
>  					addr.nl_pid, errno, strerror(errno));
>  			close(fd);
>  			return -1;
>  		}
> 
> +		if (addr.nl_pid) {
> +			syslog(LOG_WARNING, "Received packet from untrusted
> pid:%u",
> +					addr.nl_pid);
> +			continue;
> +		}
> +
>  		incoming_msg = (struct nlmsghdr *)vss_recv_buffer;
> 
>  		if (incoming_msg->nlmsg_type != NLMSG_DONE)
> 


