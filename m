Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751224AbaLOED6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 23:03:58 -0500
Received: from mail-bn1bon0131.outbound.protection.outlook.com ([157.56.111.131]:65344
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750713AbaLOEDz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 23:03:55 -0500
From: Dudley Du <dudl@cypress.com>
To: Jeremiah Mahler <jmmahler@gmail.com>, Dudley Du <dudley.dulixin@gmail.com>
CC: "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "rydberg@euromail.se" <rydberg@euromail.se>,
        "bleung@google.com" <bleung@google.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v14 01/12] input: cyapa: re-design driver to support
 multi-trackpad in one driver
Thread-Topic: [PATCH v14 01/12] input: cyapa: re-design driver to support
 multi-trackpad in one driver
Thread-Index: AQHQFbPrEsZ1UHKHOkC7E9B7mtgRk5yNYQOAgAKnTiA=
Date: Mon, 15 Dec 2014 03:49:38 +0000
Message-ID: <BN1PR06MB070B124BE4CA6D88F90000AD16F0@BN1PR06MB070.namprd06.prod.outlook.com>
References: <1418351262-8163-1-git-send-email-dudley.dulixin@gmail.com>
 <1418351262-8163-2-git-send-email-dudley.dulixin@gmail.com>
 <20141213111615.GA21729@newt.localdomain>
In-Reply-To: <20141213111615.GA21729@newt.localdomain>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.95.211.187]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR06MB069;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR06MB069;
x-forefront-prvs: 04267075BD
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(13464003)(51704005)(51164003)(24454002)(164054003)(106116001)(74316001)(76576001)(76176999)(86362001)(54356999)(46102003)(15975445007)(102836002)(40100003)(31966008)(122556002)(106356001)(4396001)(21056001)(105586002)(2656002)(66066001)(92566001)(68736005)(101416001)(99286002)(19580405001)(19580395003)(120916001)(50986999)(77156002)(99396003)(87936001)(107046002)(33656002)(97736003)(62966003)(64706001)(20776003);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR06MB069;H:BN1PR06MB070.namprd06.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for your remove and comments.

Dudley

> -----Original Message-----
> From: linux-input-owner@vger.kernel.org
> [mailto:linux-input-owner@vger.kernel.org] On Behalf Of Jeremiah Mahler
> Sent: 2014?12?13? 19:16
> To: Dudley Du
> Cc: dmitry.torokhov@gmail.com; rydberg@euromail.se; bleung@google.com;
> linux-input@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v14 01/12] input: cyapa: re-design driver to support
> multi-trackpad in one driver
>
> Dudley,
>
> A few suggestions and questions below...
>
> On Fri, Dec 12, 2014 at 10:27:31AM +0800, Dudley Du wrote:
> > In order to support multiple different chipsets and communication protocols
> > trackpad devices in one cyapa driver, the new cyapa driver is re-designed
> > with one cyapa driver core and multiple device specific functions component.
> > The cyapa driver core is contained in this patch, it supplies basic functions
> > that working with kernel and input subsystem, and also supplies the interfaces
> > that the specific devices' component can connect and work together with as
> > one driver.
> > TEST=test on Chromebooks.
> >
> > Signed-off-by: Dudley Du <dudley.dulixin@gmail.com>
> > ---
> >  drivers/input/mouse/Makefile     |    3 +-
> >  drivers/input/mouse/cyapa.c      | 1050 ++++++++++++++------------------------
> >  drivers/input/mouse/cyapa.h      |  316 ++++++++++++
> [...]
> > -{ REG_OFFSET_QUERY_BASE, QUERY_DATA_SIZE },
> > -{ BL_HEAD_OFFSET, 3 },
> > -{ BL_HEAD_OFFSET, 16 },
> > -{ BL_HEAD_OFFSET, 16 },
> > -{ BL_DATA_OFFSET, 16 },
> > -{ BL_HEAD_OFFSET, 32 },
> > -{ REG_OFFSET_QUERY_BASE, PRODUCT_ID_SIZE },
> > -{ REG_OFFSET_DATA_BASE, 32 }
> > -};
> > +const char unique_str[] = "CYTRA";
> >
> Since 'unique_str' is used to check the product id why not call it
> 'product_id'?

Thanks, I will rename it to product_id.

>
> [...]
> > +/**
> > + * cyapa_i2c_write - Execute i2c block data write operation
> > + * @cyapa: Handle to this driver
> > + * @ret: Offset of the data to written in the register map
> > + * @len: number of bytes to write
> > + * @values: Data to be written
> >   *
> > - * Note:
> > - * In trackpad device, the memory block allocated for I2C register map
> > - * is 256 bytes, so the max read block for I2C bus is 256 bytes.
> > + * Return negative errno code on error; return zero when success.
> >   */
> > -static ssize_t cyapa_smbus_read_block(struct cyapa *cyapa, u8 cmd, size_t len,
> > -      u8 *values)
> > +ssize_t cyapa_i2c_write(struct cyapa *cyapa, u8 reg,
> > + size_t len, const void *values)
> >  {
> > -ssize_t ret;
> > -u8 index;
> > -u8 smbus_cmd;
> > -u8 *buf;
> > +int ret;
> >  struct i2c_client *client = cyapa->client;
> > +char data[32], *buf;
> >
> > -if (!(SMBUS_BYTE_BLOCK_CMD_MASK & cmd))
> > -return -EINVAL;
> > -
> > -if (SMBUS_GROUP_BLOCK_CMD_MASK & cmd) {
> > -/* read specific block registers command. */
> > -smbus_cmd = SMBUS_ENCODE_RW(cmd, SMBUS_READ);
> > -ret = i2c_smbus_read_block_data(client, smbus_cmd, values);
> > -goto out;
> > -}
> > -
> > -ret = 0;
> > -for (index = 0; index * I2C_SMBUS_BLOCK_MAX < len; index++) {
> > -smbus_cmd = SMBUS_ENCODE_IDX(cmd, index);
> > -smbus_cmd = SMBUS_ENCODE_RW(smbus_cmd, SMBUS_READ);
> > -buf = values + I2C_SMBUS_BLOCK_MAX * index;
> > -ret = i2c_smbus_read_block_data(client, smbus_cmd, buf);
> > -if (ret < 0)
> > -goto out;
> > -}
> > -
> > -out:
> > -return ret > 0 ? len : ret;
> > -}
> > -
> > -static s32 cyapa_read_byte(struct cyapa *cyapa, u8 cmd_idx)
> > -{
> > -u8 cmd;
> > -
> > -if (cyapa->smbus) {
> > -cmd = cyapa_smbus_cmds[cmd_idx].cmd;
> > -cmd = SMBUS_ENCODE_RW(cmd, SMBUS_READ);
> > +if (len > 31) {
> > +buf = kzalloc(len + 1, GFP_KERNEL);
> > +if (!buf)
> > +return -ENOMEM;
> >  } else {
> > -cmd = cyapa_i2c_cmds[cmd_idx].cmd;
> > +buf = data;
> >  }
> > -return i2c_smbus_read_byte_data(cyapa->client, cmd);
> > -}
> >
> > -static s32 cyapa_write_byte(struct cyapa *cyapa, u8 cmd_idx, u8 value)
> > -{
> > -u8 cmd;
> > +buf[0] = reg;
> > +memcpy(&buf[1], values, len);
> > +ret = i2c_master_send(client, buf, len + 1);
> >
> > -if (cyapa->smbus) {
> > -cmd = cyapa_smbus_cmds[cmd_idx].cmd;
> > -cmd = SMBUS_ENCODE_RW(cmd, SMBUS_WRITE);
> > -} else {
> > -cmd = cyapa_i2c_cmds[cmd_idx].cmd;
> > -}
> > -return i2c_smbus_write_byte_data(cyapa->client, cmd, value);
> > +if (buf != data)
> > +kfree(buf);
> > +return (ret == (len + 1)) ? 0 : ((ret < 0) ? ret : -EIO);
> >  }
> >
>
> Ugh.  This is hard to read since diff replaced three functions with one,
> cyapa_i2c_write().  Nothing can be done about this, just a note for the
> other reviewers.
>
> The final cyapa_i2c_write() is shown below.
>
>   /**
>    * cyapa_i2c_write - Execute i2c block data write operation
>    * @cyapa: Handle to this driver
>    * @ret: Offset of the data to written in the register map
>    * @len: number of bytes to write
>    * @values: Data to be written
>    *
>    * Return negative errno code on error; return zero when success.
>    */
>   ssize_t cyapa_i2c_write(struct cyapa *cyapa, u8 reg,
>                                            size_t len, const void *values)
>   {
>           int ret;
>           struct i2c_client *client = cyapa->client;
>           char data[32], *buf;
>
>           if (len > 31) {
>                   buf = kzalloc(len + 1, GFP_KERNEL);
>                   if (!buf)
>                           return -ENOMEM;
>           } else {
>                   buf = data;
>           }
>
>           buf[0] = reg;
>           memcpy(&buf[1], values, len);
>           ret = i2c_master_send(client, buf, len + 1);
>
>           if (buf != data)
>                   kfree(buf);
>           return (ret == (len + 1)) ? 0 : ((ret < 0) ? ret : -EIO);
>   }
>
> What is interesting about this code is that it switches between buffers
> depending on length.  If it is less than or equal to 31 bytes a static
> buffer is used.  If it is larger, memory is allocated.
>
> Is this complexity justified or is this premature optimization?
>
> I could only find one place where cyapa_i2c_write() was used and it only
> involved 2 bytes so 32 is plenty.
>
> Why not simplify it and only use the static buffer and just reject
> anything that is too large?
>
>   ssize_t cyapa_i2c_write(struct cyapa *cyapa, u8 reg,
>                                            size_t len, const void *values)
>   {
>           int ret;
>           struct i2c_client *client = cyapa->client;
>           char buf[32];
>
>           if (len > 31)
>   return -ENOMEM;
>
>           buf[0] = reg;
>           memcpy(&buf[1], values, len);
>           ret = i2c_master_send(client, buf, len + 1);
>
>           return (ret == (len + 1)) ? 0 : ((ret < 0) ? ret : -EIO);
>   }
>
> [...]

Thanks, I will modify it based on your suggestion.

>
> --
> - Jeremiah Mahler
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

This message and any attachments may contain Cypress (or its subsidiaries) confidential information. If it has been received in error, please advise the sender and immediately delete this message.
